/*
 * export_wav.cpp - Export audio from native firmware to WAV files
 *
 * Usage:
 *   ./export_wav <ic5> <ic6> <ic7> <paramsrom> rd200
 *   ./export_wav <ic5a> <ic6a> <ic7a> <paramsrom> mks20 <ic5b> <ic6b> <ic7b>
 */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <vector>

#include "sound_chip.h"
#include "synth_firmware.h"

static constexpr int OUTPUT_SCALE = 4;

static void write_wav(const char *path, const std::vector<int16_t> &samples, int sample_rate) {
    FILE *f = fopen(path, "wb");
    if (!f) { fprintf(stderr, "Can't write %s\n", path); return; }
    uint32_t data_size = samples.size() * 2, file_size = 36 + data_size;
    fwrite("RIFF",1,4,f); fwrite(&file_size,4,1,f); fwrite("WAVE",1,4,f);
    fwrite("fmt ",1,4,f);
    uint32_t fs=16; uint16_t af=1,ch=1; uint32_t sr=sample_rate,br=sample_rate*2; uint16_t ba=2,bits=16;
    fwrite(&fs,4,1,f); fwrite(&af,2,1,f); fwrite(&ch,2,1,f);
    fwrite(&sr,4,1,f); fwrite(&br,4,1,f); fwrite(&ba,2,1,f); fwrite(&bits,2,1,f);
    fwrite("data",1,4,f); fwrite(&data_size,4,1,f);
    fwrite(samples.data(),2,samples.size(),f);
    fclose(f);
    printf("  Wrote %s (%zu samples, %.2fs at %dHz)\n", path, samples.size(),
           (double)samples.size()/sample_rate, sample_rate);
}

static uint8_t* load_file(const char *path, size_t sz) {
    FILE *f=fopen(path,"rb"); if(!f){fprintf(stderr,"Failed: %s\n",path);return nullptr;}
    uint8_t *d=(uint8_t*)malloc(sz); fread(d,1,sz,f); fclose(f); return d;
}

template<int W> static unsigned bitswap(unsigned val, ...) {
    va_list ap; va_start(ap,val); int bits[W];
    for(int i=W-1;i>=0;i--) bits[i]=va_arg(ap,int);
    va_end(ap); unsigned r=0;
    for(int i=0;i<W;i++) if(val&(1<<bits[i])) r|=(1<<i);
    return r;
}
static void descramble_params(const uint8_t *s, uint8_t *d, size_t sz) {
    for(size_t i=0;i<sz;i++) d[i]=bitswap<8>(s[bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}

struct Event { int sample; uint8_t s, d1, d2; };
static std::vector<Event> build_sequence(int sr) {
    std::vector<Event> ev; int t = 0;

    // Scale with varying velocity
    uint8_t sc[]={48,50,52,53,55,57,59,60,62,64,65,67,69,71,72};
    for(int i=0;i<15;i++){
        uint8_t v=30+i*8; if(v>127)v=127;
        ev.push_back({t,0x90,sc[i],v}); t+=sr/4;
        ev.push_back({t,0x80,sc[i],0}); t+=sr/10;
    }
    t+=sr/2;

    // Chord
    ev.push_back({t,0x90,60,120}); ev.push_back({t,0x90,64,120}); ev.push_back({t,0x90,67,120});
    t+=sr; ev.push_back({t,0x80,60,0}); ev.push_back({t,0x80,64,0}); ev.push_back({t,0x80,67,0});
    t+=sr/2;

    // Bass + high
    ev.push_back({t,0x90,36,30}); t+=sr; ev.push_back({t,0x80,36,0}); t+=sr/2;
    ev.push_back({t,0x90,84,127}); t+=sr/2; ev.push_back({t,0x80,84,0}); t+=sr/2;

    // Fast repeated
    for(int i=0;i<8;i++){
        ev.push_back({t,0x90,60,(uint8_t)((i%2==0)?100:50)}); t+=sr/8;
        ev.push_back({t,0x80,60,0}); t+=sr/20;
    }
    t+=sr/2;

    // Sustain test
    ev.push_back({t,0xB0,64,127});
    for(int i=0;i<6;i++){
        uint8_t note=60+i*4;
        ev.push_back({t,0x90,note,90}); t+=sr/5;
        ev.push_back({t,0x80,note,0});
    }
    t+=sr/2;
    ev.push_back({t,0xB0,64,0}); t+=sr;

    // Voice stealing
    for(int i=0;i<20;i++){
        uint8_t note=36+i*3; if(note>96) note=96;
        ev.push_back({t,0x90,note,100}); t+=sr/20;
    }
    t+=sr;
    for(int i=0;i<20;i++){
        uint8_t note=36+i*3; if(note>96) note=96;
        ev.push_back({t,0x80,note,0});
    }
    t+=sr;

    return ev;
}
static int seq_len(const std::vector<Event>&ev){int m=0;for(auto&e:ev)if(e.sample>m)m=e.sample;return m+10000;}

struct PatchInfo { const char *name; int sample_rate; int pgm_index; const uint8_t *ic5,*ic6,*ic7; };

int main(int argc, char *argv[]) {
    if (argc < 6) {
        fprintf(stderr, "Usage:\n  %s <ic5> <ic6> <ic7> <paramsrom> rd200\n"
                "  %s <ic5a> <ic6a> <ic7a> <paramsrom> mks20 <ic5b> <ic6b> <ic7b>\n", argv[0], argv[0]);
        return 1;
    }

    uint8_t *ic5a=load_file(argv[1],0x20000), *ic6a=load_file(argv[2],0x20000),
            *ic7a=load_file(argv[3],0x20000), *paramsrom_raw=load_file(argv[4],0x20000);
    if(!ic5a||!ic6a||!ic7a||!paramsrom_raw) return 1;

    bool is_rd200 = (strcmp(argv[5],"rd200")==0);
    uint8_t *ic5b=nullptr, *ic6b=nullptr, *ic7b=nullptr;
    if (!is_rd200 && argc >= 9) {
        ic5b=load_file(argv[6],0x20000); ic6b=load_file(argv[7],0x20000); ic7b=load_file(argv[8],0x20000);
    }

    uint8_t paramsrom[0x20000];
    descramble_params(paramsrom_raw, paramsrom, 0x20000);

    auto fmt = is_rd200 ? ParamsRomFormat::RD200 : ParamsRomFormat::MKS20;
    PatchSet patch_set;
    patch_set.load(paramsrom, fmt);

    const char *names[] = {"Piano_1","Piano_2","Piano_3","Harpsichord","Clavi","Vibraphone","EPiano_1","EPiano_2"};
    static const int mks20_romset[] = {0,0,0,1,1,1,1,1}; // 0=set A, 1=set B

    for (int pgm = 0; pgm < 8; pgm++) {
        const PatchData &pd = patch_set.patches[pgm];
        int sr = (pd.flags & 0x04) ? 20000 : 32000;
        printf("\n=== %d: %s (%dHz) ===\n", pgm, names[pgm], sr);

        const uint8_t *pic5 = ic5a, *pic6 = ic6a, *pic7 = ic7a;
        if (!is_rd200 && mks20_romset[pgm] && ic5b) { pic5=ic5b; pic6=ic6b; pic7=ic7b; }

        SoundChip chip(pic5, pic6, pic7);
        SynthFirmware fw(chip);
        fw.loadPatch(pd);

        auto events = build_sequence(sr);
        int total = seq_len(events);

        std::vector<int16_t> samples; samples.reserve(total);
        int ei = 0;
        for (int s = 0; s < total; s++) {
            while (ei < (int)events.size() && events[ei].sample <= s) {
                fw.sendMidi(events[ei].s, events[ei].d1, events[ei].d2);
                ei++;
            }
            samples.push_back((int16_t)(fw.generateSample() / OUTPUT_SCALE));
        }
        char fn[256]; snprintf(fn, sizeof(fn), "%s.wav", names[pgm]);
        write_wav(fn, samples, sr);
    }

    printf("\nDone.\n");
    free(ic5a); free(ic6a); free(ic7a); free(paramsrom_raw);
    if(ic5b){free(ic5b);free(ic6b);free(ic7b);}
    return 0;
}
