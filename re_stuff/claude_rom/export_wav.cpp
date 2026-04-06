/*
 * export_wav.cpp - Export audio from EMU and NATIVE
 *
 * Modes:
 *   ./export_wav <ic5> <ic6> <ic7> <progrom> <paramsrom> rd200
 *     → RD200: 8 programs, single set of sample ROMs
 *
 *   ./export_wav <ic5a> <ic6a> <ic7a> <progrom> <paramsrom> mks20 <ic5b> <ic6b> <ic7b>
 *     → MKS-20: 8 patches, ROM set A (ic5a/6a/7a) for patches 0-2,
 *               ROM set B (ic5b/6b/7b) for patches 3-7
 */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <vector>

#include "../../librdpiano/include/sound_chip.h"
#include "../../librdpiano/include/mcu.h"
#include "synth_firmware.h"

static constexpr int OUTPUT_SCALE = 4;

static void write_wav(const char *path, const std::vector<int16_t> &samples, int sample_rate) {
    FILE *f = fopen(path, "wb");
    if (!f) { fprintf(stderr, "Can't write %s\n", path); return; }
    uint32_t data_size = samples.size() * 2;
    uint32_t file_size = 36 + data_size;
    fwrite("RIFF",1,4,f); fwrite(&file_size,4,1,f); fwrite("WAVE",1,4,f);
    fwrite("fmt ",1,4,f);
    uint32_t fmt_size=16; uint16_t afmt=1,ch=1;
    uint32_t sr=sample_rate, br=sample_rate*2;
    uint16_t ba=2, bits=16;
    fwrite(&fmt_size,4,1,f); fwrite(&afmt,2,1,f); fwrite(&ch,2,1,f);
    fwrite(&sr,4,1,f); fwrite(&br,4,1,f); fwrite(&ba,2,1,f); fwrite(&bits,2,1,f);
    fwrite("data",1,4,f); fwrite(&data_size,4,1,f);
    fwrite(samples.data(),2,samples.size(),f);
    fclose(f);
    printf("  Wrote %s (%zu samples, %.2fs at %dHz)\n", path, samples.size(),
           (double)samples.size()/sample_rate, sample_rate);
}

static uint8_t* load_file(const char *path, size_t sz) {
    FILE *f=fopen(path,"rb"); if(!f){fprintf(stderr,"Failed: %s\n",path);return nullptr;}
    uint8_t *d=(uint8_t*)malloc(sz); size_t n=fread(d,1,sz,f); fclose(f);
    if(n!=sz){free(d);return nullptr;} return d;
}

template<int W> static unsigned bitswap(unsigned val, ...) {
    va_list ap; va_start(ap,val); int bits[W];
    for(int i=W-1;i>=0;i--) bits[i]=va_arg(ap,int);
    va_end(ap); unsigned r=0;
    for(int i=0;i<W;i++) if(val&(1<<bits[i])) r|=(1<<i);
    return r;
}
static void descramble_cpub(const uint8_t *s, uint8_t *d, size_t sz) {
    for(size_t i=0;i<sz;i++) d[i]=bitswap<8>(s[bitswap<14>(i,13,12,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}
static void descramble_params(const uint8_t *s, uint8_t *d, size_t sz) {
    for(size_t i=0;i<sz;i++) d[i]=bitswap<8>(s[bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}

struct Event { int sample; uint8_t s, d1, d2; };
static std::vector<Event> build_sequence(int pgm, int sr) {
    std::vector<Event> ev; int t=0;
    ev.push_back({t,0xC0,(uint8_t)pgm,0x00}); t+=sr/2;

    // --- Section 1: Scale with varying velocity ---
    uint8_t sc[]={48,50,52,53,55,57,59,60,62,64,65,67,69,71,72};
    for(int i=0;i<15;i++){
        uint8_t v=30+i*8; if(v>127)v=127;
        ev.push_back({t,0x90,sc[i],v}); t+=sr/4;
        ev.push_back({t,0x80,sc[i],0}); t+=sr/10;
    }
    t+=sr/2;

    // --- Section 2: Chord ---
    ev.push_back({t,0x90,60,120}); ev.push_back({t,0x90,64,120}); ev.push_back({t,0x90,67,120});
    t+=sr; ev.push_back({t,0x80,60,0}); ev.push_back({t,0x80,64,0}); ev.push_back({t,0x80,67,0});
    t+=sr/2;

    // --- Section 3: Bass + high ---
    ev.push_back({t,0x90,36,30}); t+=sr; ev.push_back({t,0x80,36,0}); t+=sr/2;
    ev.push_back({t,0x90,84,127}); t+=sr/2; ev.push_back({t,0x80,84,0}); t+=sr/2;

    // --- Section 4: Fast repeated notes ---
    for(int i=0;i<8;i++){
        ev.push_back({t,0x90,60,(uint8_t)((i%2==0)?100:50)}); t+=sr/8;
        ev.push_back({t,0x80,60,0}); t+=sr/20;
    }
    t+=sr/2;

    // --- Section 5: Sustain pedal test ---
    // Pedal down, play arpeggio, pedal up (all notes should ring then release)
    ev.push_back({t,0xB0,64,127}); // sustain ON
    for(int i=0;i<6;i++){
        uint8_t note = 60 + i*4; // C4, E4, G#4, C5, E5, G#5
        ev.push_back({t,0x90,note,90});
        t+=sr/5; // 0.2s per note
        ev.push_back({t,0x80,note,0}); // release key but sustain holds it
    }
    t+=sr/2; // let them ring
    ev.push_back({t,0xB0,64,0}); // sustain OFF → all notes release
    t+=sr; // wait for release tail

    // --- Section 6: Sustain pedal with re-strikes ---
    ev.push_back({t,0xB0,64,127}); // sustain ON
    ev.push_back({t,0x90,60,100}); t+=sr/4;
    ev.push_back({t,0x80,60,0}); t+=sr/4;
    ev.push_back({t,0x90,60,80}); t+=sr/4;  // re-strike same note while sustained
    ev.push_back({t,0x80,60,0}); t+=sr/4;
    ev.push_back({t,0xB0,64,0}); // sustain OFF
    t+=sr/2;

    // --- Section 7: Voice stealing - play more notes than voices ---
    // Play 20 overlapping notes (more than 16 voice slots)
    for(int i=0;i<20;i++){
        uint8_t note = 36 + i*3; // spread across keyboard
        if(note > 96) note = 96;
        ev.push_back({t,0x90,note,100});
        t+=sr/20; // 50ms apart - notes overlap heavily
    }
    t+=sr; // let them ring
    // Release all
    for(int i=0;i<20;i++){
        uint8_t note = 36 + i*3;
        if(note > 96) note = 96;
        ev.push_back({t,0x80,note,0});
    }
    t+=sr/2;

    // --- Section 8: Dense chord with sustain (max polyphony stress) ---
    ev.push_back({t,0xB0,64,127}); // sustain ON
    // Play a big cluster chord
    for(int i=0;i<10;i++){
        ev.push_back({t,0x90,(uint8_t)(48+i*2),110});
    }
    t+=sr/2;
    // Release keys (but sustain holds)
    for(int i=0;i<10;i++){
        ev.push_back({t,0x80,(uint8_t)(48+i*2),0});
    }
    t+=sr/2;
    // Play another chord on top (voice stealing while sustained)
    for(int i=0;i<10;i++){
        ev.push_back({t,0x90,(uint8_t)(60+i*2),100});
    }
    t+=sr/2;
    // Release sustain → everything releases
    ev.push_back({t,0xB0,64,0});
    t+=sr;

    t+=sr/2; return ev;
}
static int seq_len(const std::vector<Event>&ev){int m=0;for(auto&e:ev)if(e.sample>m)m=e.sample;return m+10000;}

struct PatchInfo {
    const char *name;
    int sample_rate;
    size_t from_addr;        // IC18 offset for loadSounds
    const uint8_t *ic5, *ic6, *ic7;  // sample ROMs (raw, not descrambled)
    const uint8_t *paramsrom_raw;     // IC18 ROM (raw)
};

int main(int argc, char *argv[]) {
    if (argc < 7) {
        fprintf(stderr, "Usage:\n");
        fprintf(stderr, "  %s <ic5> <ic6> <ic7> <progrom> <paramsrom> rd200\n", argv[0]);
        fprintf(stderr, "  %s <ic5a> <ic6a> <ic7a> <progrom> <paramsrom> mks20 <ic5b> <ic6b> <ic7b>\n", argv[0]);
        return 1;
    }

    uint8_t *ic5a=load_file(argv[1],0x20000);
    uint8_t *ic6a=load_file(argv[2],0x20000);
    uint8_t *ic7a=load_file(argv[3],0x20000);
    uint8_t *progrom_raw=load_file(argv[4],0x2000);
    uint8_t *paramsrom_raw=load_file(argv[5],0x20000);
    if(!ic5a||!ic6a||!ic7a||!progrom_raw||!paramsrom_raw) return 1;

    bool is_rd200 = (strcmp(argv[6],"rd200")==0);
    bool is_mks20 = (strcmp(argv[6],"mks20")==0);

    uint8_t *ic5b=nullptr, *ic6b=nullptr, *ic7b=nullptr;
    if (is_mks20) {
        if (argc < 10) { fprintf(stderr, "MKS-20 mode needs 3 extra ROM files for set B\n"); return 1; }
        ic5b=load_file(argv[7],0x20000);
        ic6b=load_file(argv[8],0x20000);
        ic7b=load_file(argv[9],0x20000);
        if(!ic5b||!ic6b||!ic7b) return 1;
    }

    uint8_t progrom[0x2000], paramsrom[0x20000];
    descramble_cpub(progrom_raw, progrom, 0x2000);
    descramble_params(paramsrom_raw, paramsrom, 0x20000);

    PatchInfo patches[8];

    if (is_rd200) {
        const char *names[]={"Piano_1","Piano_2","Piano_3","Harpsichord","Clavi","Vibraphone","EPiano_1","EPiano_2"};
        for(int p=0;p<8;p++){
            int bank=paramsrom[p*3]; int addr=(paramsrom[p*3+1]<<8)|paramsrom[p*3+2];
            uint8_t flags=paramsrom[bank*0x8000+(addr-0x4000)];
            patches[p]={names[p], (flags&4)?20000:32000,
                        (size_t)bank*0x8000+(addr-0x4000),
                        ic5a,ic6a,ic7a,paramsrom_raw};
        }
        printf("RD200 mode: 8 programs\n");
    } else if (is_mks20) {
        const char *names[]={"Piano_1","Piano_2","Piano_3","Harpsichord","Clavi","Vibraphone","EPiano_1","EPiano_2"};
        // From JUCE plugin patchToOffset, patchToRomSet, sampleRates
        static const size_t offsets[]={0x000000,0x008000,0x010000,0x018000,0x003c20,0x00ab50,0x014260,0x01bef0};
        static const int rates[]={20000,20000,20000,32000,32000,20000,20000,32000};
        // JUCE: patches 0-2 use ROM set A, patches 3-7 use ROM set B
        static const int romset[]={0,0,0,1,1,1,1,1};
        for(int p=0;p<8;p++){
            patches[p]={names[p], rates[p], offsets[p],
                        romset[p]?ic5b:ic5a, romset[p]?ic6b:ic6a, romset[p]?ic7b:ic7a,
                        paramsrom_raw};
        }
        printf("MKS-20 mode: 8 patches (ROM set A for 0-2, ROM set B for 3-7)\n");
    } else {
        fprintf(stderr, "Unknown mode: %s (use rd200 or mks20)\n", argv[6]);
        return 1;
    }

    for (int pgm=0; pgm<8; pgm++) {
        PatchInfo &pi = patches[pgm];
        int sr=pi.sample_rate; bool sr32=(sr==32000);
        printf("\n=== %d: %s (%dHz) ===\n", pgm, pi.name, sr);

        auto events = build_sequence(pgm, sr);
        int total = seq_len(events);

        // EMU: load correct ROM set + offset for this patch
        {
            Mcu emu(pi.ic5, pi.ic6, pi.ic7, progrom_raw, pi.paramsrom_raw);
            emu.loadSounds(pi.ic5, pi.ic6, pi.ic7, pi.paramsrom_raw, pi.from_addr);
            emu.reset();
            for(int i=0;i<2000;i++) emu.generate_next_sample(sr32);

            // EMU always uses program 0 (fake header has one entry)
            auto emu_ev=events;
            for(auto&e:emu_ev) if(e.s==0xC0) e.d1=0;

            std::vector<int16_t> samples; samples.reserve(total);
            int ei=0;
            for(int s=0;s<total;s++){
                while(ei<(int)emu_ev.size()&&emu_ev[ei].sample<=s){
                    emu.sendMidiCmd(emu_ev[ei].s,emu_ev[ei].d1,emu_ev[ei].d2); ei++;}
                samples.push_back((int16_t)(emu.generate_next_sample(sr32)/OUTPUT_SCALE));
            }
            char fn[256]; snprintf(fn,sizeof(fn),"emu_%s.wav",pi.name);
            write_wav(fn,samples,sr);
        }

        // NATIVE: use correct ROM set
        {
            SoundChip chip(pi.ic5, pi.ic6, pi.ic7);
            // For native, we need descrambled params specific to this patch's from_addr
            // But native handles full IC18 mapping internally
            auto fmt = is_rd200 ? ParamsRomFormat::RD200 : ParamsRomFormat::MKS20;
            SynthFirmware native(chip, paramsrom, fmt);

            // Load correct sample ROMs for this patch
            chip.load_samples(pi.ic5, pi.ic6, pi.ic7);

            std::vector<int16_t> samples; samples.reserve(total);
            int ei=0;
            for(int s=0;s<total;s++){
                while(ei<(int)events.size()&&events[ei].sample<=s){
                    native.sendMidiCmd(events[ei].s,events[ei].d1,events[ei].d2); ei++;}
                samples.push_back((int16_t)(native.generate_next_sample(sr32)/OUTPUT_SCALE));
            }
            char fn[256]; snprintf(fn,sizeof(fn),"native_%s.wav",pi.name);
            write_wav(fn,samples,sr);
        }
    }

    printf("\nDone.\n");
    free(ic5a);free(ic6a);free(ic7a);free(progrom_raw);free(paramsrom_raw);
    if(ic5b){free(ic5b);free(ic6b);free(ic7b);}
    return 0;
}
