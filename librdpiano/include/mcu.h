#ifndef MCU_H
#define MCU_H

#include <stdio.h>
#include <queue>

#include "mame_utils.h"
#include "sound_chip.h"

enum
  {
    M6800_IRQ_LINE = 0, // IRQ line number

    M6800_LINE_MAX
  };
  enum
  {
    M6801_TIN_LINE = M6800_LINE_MAX, // P20/TIN Input Capture line (edge sense). Active edge is selectable by internal reg.
    M6801_IS3_LINE, // SC1/IOS/IS3 (P54/IS on HD6301Y)
    M6801_STBY_LINE, // STBY pin, or internal standby

    M6801_LINE_MAX
  };

class Mcu {
public:
  Mcu(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_progrom, const u8 *temp_paramsrom);
  ~Mcu();
  
  typedef void (Mcu::*op_func)();

  void execute_one();
  void execute_set_input(int irqline, int state);
  void execute_run();

  std::queue<u8> commands_queue;

	s16 generate_next_sample(bool sampleRate32 = false);
	bool current_sample_rate = false;

	void sendMidiCmd(u8 cmd, u8 data1, u8 data2);
	void loadSounds(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_paramsrom);

private:
  // Board specific
  u8 read_byte(u16 addr);
  void write_byte(u16 addr, u8 data);

  SoundChip sound_chip;

  u8 latch_val = 0x00;
  u8 program_rom[0x2000];
  u8 params_rom[0x20000];
  u8 ram[0x10000] = {0};

  // Generic CPU
  void take_trap();
  void check_irq_lines();
  void eat_cycles();
  u32 RM16(u32 Addr);
	void WM16(u32 Addr, PAIR *p);
  void enter_interrupt(const char *message, u16 irq_vector);
  void increment_counter(int amount);

  PAIR m_ppc = {0,0};         // Previous program counter
	PAIR m_pc = {0,0};          // Program counter
	PAIR m_s = {0,0};           // Stack pointer
	PAIR m_x = {0,0};           // Index register
	PAIR m_d = {0,0};           // Accumulators
	PAIR m_ea = {0,0};          // effective address (temporary variable)
	u8 m_cc = 0;            // Condition codes
	u8 m_wai_state = 0;     // WAI opcode state (or sleep opcode state)
	u8 m_nmi_state = 0;     // NMI line state
	u8 m_nmi_pending = 0;   // NMI pending
	u8 m_irq_state[5] = {0};  // IRQ line state [IRQ1,TIN,IS3,..]

  u8 m_tcsr = 0;            // Timer Control and Status Register
  PAIR m_counter = {0,0};       // free running counter
  u8 m_pending_tcsr = 0;    // pending IRQ flag for clear IRQflag process
  u16 m_input_capture = 0;  // input capture

  u8 tcsr_r();
  void tcsr_w(u8 data);

  int m_icount = 0;

  static const u8 flags8i[256];
	static const u8 flags8d[256];
  enum
	{
		M6800_WAI = 8,    // set when WAI is waiting for an interrupt
		M6800_SLP = 0x10  // HD63701 only
	};

  static const u8 cycles_63701[256];
  
  static const op_func hd63701_insn[256];
  void aba();
	void abx();
	void adca_di();
	void adca_ex();
	void adca_im();
	void adca_ix();
	void adcb_di();
	void adcb_ex();
	void adcb_im();
	void adcb_ix();
	void adcx_im();
	void adda_di();
	void adda_ex();
	void adda_im();
	void adda_ix();
	void addb_di();
	void addb_ex();
	void addb_im();
	void addb_ix();
	void addd_di();
	void addd_ex();
	void addx_ex();
	void addd_im();
	void addd_ix();
	void aim_di();
	void aim_ix();
	void anda_di();
	void anda_ex();
	void anda_im();
	void anda_ix();
	void andb_di();
	void andb_ex();
	void andb_im();
	void andb_ix();
	void asl_ex();
	void asl_ix();
	void asla();
	void aslb();
	void asld();
	void asr_ex();
	void asr_ix();
	void asra();
	void asrb();
	void bcc();
	void bcs();
	void beq();
	void bge();
	void bgt();
	void bhi();
	void bita_di();
	void bita_ex();
	void bita_im();
	void bita_ix();
	void bitb_di();
	void bitb_ex();
	void bitb_im();
	void bitb_ix();
	void ble();
	void bls();
	void blt();
	void bmi();
	void bne();
	void bpl();
	void bra();
	void brn();
	void bsr();
	void bvc();
	void bvs();
	void cba();
	void clc();
	void cli();
	void clr_ex();
	void clr_ix();
	void clra();
	void clrb();
	void clv();
	void cmpa_di();
	void cmpa_ex();
	void cmpa_im();
	void cmpa_ix();
	void cmpb_di();
	void cmpb_ex();
	void cmpb_im();
	void cmpb_ix();
	void cmpx_di();
	void cmpx_ex();
	void cmpx_im();
	void cmpx_ix();
	void com_ex();
	void com_ix();
	void coma();
	void comb();
	void daa();
	void dec_ex();
	void dec_ix();
	void deca();
	void decb();
	void des();
	void dex();
	void eim_di();
	void eim_ix();
	void eora_di();
	void eora_ex();
	void eora_im();
	void eora_ix();
	void eorb_di();
	void eorb_ex();
	void eorb_im();
	void eorb_ix();
	void illegl1();
	void illegl2();
	void illegl3();
	void inc_ex();
	void inc_ix();
	void inca();
	void incb();
	void ins();
	void inx();
	void jmp_ex();
	void jmp_ix();
	void jsr_di();
	void jsr_ex();
	void jsr_ix();
	void lda_di();
	void lda_ex();
	void lda_im();
	void lda_ix();
	void ldb_di();
	void ldb_ex();
	void ldb_im();
	void ldb_ix();
	void ldd_di();
	void ldd_ex();
	void ldd_im();
	void ldd_ix();
	void lds_di();
	void lds_ex();
	void lds_im();
	void lds_ix();
	void ldx_di();
	void ldx_ex();
	void ldx_im();
	void ldx_ix();
	void lsr_ex();
	void lsr_ix();
	void lsra();
	void lsrb();
	void lsrd();
	void mul();
	void neg_ex();
	void neg_ix();
	void nega();
	void negb();
	void nop();
	void oim_di();
	void oim_ix();
	void ora_di();
	void ora_ex();
	void ora_im();
	void ora_ix();
	void orb_di();
	void orb_ex();
	void orb_im();
	void orb_ix();
	void psha();
	void pshb();
	void pshx();
	void pula();
	void pulb();
	void pulx();
	void rol_ex();
	void rol_ix();
	void rola();
	void rolb();
	void ror_ex();
	void ror_ix();
	void rora();
	void rorb();
	void rti();
	void rts();
	void sba();
	void sbca_di();
	void sbca_ex();
	void sbca_im();
	void sbca_ix();
	void sbcb_di();
	void sbcb_ex();
	void sbcb_im();
	void sbcb_ix();
	void sec();
	void sei();
	void sev();
	void slp();
	void sta_di();
	void sta_ex();
	void sta_im();
	void sta_ix();
	void stb_di();
	void stb_ex();
	void stb_im();
	void stb_ix();
	void std_di();
	void std_ex();
	void std_im();
	void std_ix();
	void sts_di();
	void sts_ex();
	void sts_im();
	void sts_ix();
	void stx_di();
	void stx_ex();
	void stx_im();
	void stx_ix();
	void suba_di();
	void suba_ex();
	void suba_im();
	void suba_ix();
	void subb_di();
	void subb_ex();
	void subb_im();
	void subb_ix();
	void subd_di();
	void subd_ex();
	void subd_im();
	void subd_ix();
	void swi();
	void tab();
	void tap();
	void tba();
	void tim_di();
	void tim_ix();
	void tpa();
	void tst_ex();
	void tst_ix();
	void tsta();
	void tstb();
	void tsx();
	void txs();
	void undoc1();
	void undoc2();
	void wai();
	void xgdx();
	void cpx_di();
	void cpx_ex();
	void cpx_im();
	void cpx_ix();
	void trap();
	void btst_ix();
	void stx_nsc();
};

#endif
