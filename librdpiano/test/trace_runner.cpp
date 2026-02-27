#include <cerrno>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "mcu.h"
#include "rd200_trace.h"
#include "rdpiano_program_map.h"

namespace {

constexpr size_t kWaveRomSize = 0x20000;
constexpr size_t kCpuRomSize = 0x2000;

struct CliArgs {
  std::string runtime = "interpreter";
  std::string corpus;
  std::string out;
  std::string stats_out;
  std::string rom_dir = ".";
  int program = 0;
};

struct RomBlobs {
  std::vector<uint8_t> mks20a_ic5 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20a_ic6 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20a_ic7 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20b_ic5 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20b_ic6 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20b_ic7 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mk80_ic5 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mk80_ic6 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mk80_ic7 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mks20_ic18 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> mk80_ic18 = std::vector<uint8_t>(kWaveRomSize);
  std::vector<uint8_t> rd200_b = std::vector<uint8_t>(kCpuRomSize);

  RomSet mks20a_set{};
  RomSet mks20b_set{};
  RomSet mk80_set{};
};

bool load_rom_file(const std::string &path, uint8_t *data, size_t len)
{
  FILE *f = std::fopen(path.c_str(), "rb");
  if (!f)
  {
    std::fprintf(stderr, "failed to open ROM: %s\n", path.c_str());
    return false;
  }

  const size_t n = std::fread(data, 1, len, f);
  std::fclose(f);
  if (n != len)
  {
    std::fprintf(stderr, "short ROM read: %s (%zu/%zu)\n", path.c_str(), n, len);
    return false;
  }

  return true;
}

std::string path_join(const std::string &a, const std::string &b)
{
  if (a.empty())
    return b;
  if (a.back() == '/')
    return a + b;
  return a + "/" + b;
}

bool parse_int(const std::string &token, int *out)
{
  if (!out)
    return false;
  char *end = nullptr;
  errno = 0;
  const long v = std::strtol(token.c_str(), &end, 0);
  if (errno != 0 || end == token.c_str() || *end != '\0')
    return false;
  *out = static_cast<int>(v);
  return true;
}

bool parse_cli(int argc, char **argv, CliArgs *args)
{
  if (!args)
    return false;

  for (int i = 1; i < argc; i++)
  {
    const std::string k = argv[i];
    const auto next = [&](std::string *dst) -> bool {
      if (i + 1 >= argc)
        return false;
      *dst = argv[++i];
      return true;
    };

    if (k == "--runtime")
    {
      if (!next(&args->runtime))
        return false;
    }
    else if (k == "--corpus")
    {
      if (!next(&args->corpus))
        return false;
    }
    else if (k == "--out")
    {
      if (!next(&args->out))
        return false;
    }
    else if (k == "--rom-dir")
    {
      if (!next(&args->rom_dir))
        return false;
    }
    else if (k == "--stats-out")
    {
      if (!next(&args->stats_out))
        return false;
    }
    else if (k == "--program")
    {
      std::string s;
      if (!next(&s))
        return false;
      if (!parse_int(s, &args->program))
        return false;
    }
    else
    {
      std::fprintf(stderr, "unknown arg: %s\n", k.c_str());
      return false;
    }
  }

  if (args->runtime != "interpreter" && args->runtime != "lifted")
  {
    std::fprintf(stderr, "runtime must be interpreter or lifted\n");
    return false;
  }

  if (args->corpus.empty() || args->out.empty())
  {
    std::fprintf(stderr, "--corpus and --out are required\n");
    return false;
  }

  return true;
}

bool load_roms(const std::string &rom_dir, RomBlobs *roms)
{
  if (!roms)
    return false;

  if (!load_rom_file(path_join(rom_dir, "mks20_15179738.BIN"), roms->mks20a_ic5.data(), roms->mks20a_ic5.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179737.BIN"), roms->mks20a_ic6.data(), roms->mks20a_ic6.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179736.BIN"), roms->mks20a_ic7.data(), roms->mks20a_ic7.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179741.BIN"), roms->mks20b_ic5.data(), roms->mks20b_ic5.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179740.BIN"), roms->mks20b_ic6.data(), roms->mks20b_ic6.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179739.BIN"), roms->mks20b_ic7.data(), roms->mks20b_ic7.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "MK80_IC5.bin"), roms->mk80_ic5.data(), roms->mk80_ic5.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "MK80_IC6.bin"), roms->mk80_ic6.data(), roms->mk80_ic6.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "MK80_IC7.bin"), roms->mk80_ic7.data(), roms->mk80_ic7.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "mks20_15179757.BIN"), roms->mks20_ic18.data(), roms->mks20_ic18.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "MK80_IC18.bin"), roms->mk80_ic18.data(), roms->mk80_ic18.size()))
    return false;
  if (!load_rom_file(path_join(rom_dir, "RD200_B.bin"), roms->rd200_b.data(), roms->rd200_b.size()))
    return false;

  roms->mks20a_set = {roms->mks20a_ic5.data(), roms->mks20a_ic6.data(), roms->mks20a_ic7.data(), roms->mks20_ic18.data()};
  roms->mks20b_set = {roms->mks20b_ic5.data(), roms->mks20b_ic6.data(), roms->mks20b_ic7.data(), roms->mks20_ic18.data()};
  roms->mk80_set = {roms->mk80_ic5.data(), roms->mk80_ic6.data(), roms->mk80_ic7.data(), roms->mk80_ic18.data()};
  set_program_rom_sets(&roms->mks20a_set, &roms->mks20b_set, &roms->mk80_set);

  return true;
}

void apply_program(Mcu *mcu, int program, bool *mode32)
{
  if (!mcu || !mode32)
    return;

  const ProgramConfig cfg = get_program_config(program);
  if (!cfg.rom_set)
    return;

  mcu->loadSounds(cfg.rom_set->ic5, cfg.rom_set->ic6, cfg.rom_set->ic7, cfg.rom_set->ic18, cfg.params_offset);
  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);
  *mode32 = (cfg.source_sample_rate == 32000);
}

bool run_corpus(Mcu *mcu, const std::string &corpus_path, bool *mode32)
{
  std::ifstream in(corpus_path);
  if (!in.good())
  {
    std::fprintf(stderr, "failed to open corpus: %s\n", corpus_path.c_str());
    return false;
  }

  std::string line;
  int line_no = 0;
  while (std::getline(in, line))
  {
    line_no++;
    const auto hash = line.find('#');
    if (hash != std::string::npos)
      line = line.substr(0, hash);

    std::istringstream iss(line);
    std::string op;
    if (!(iss >> op))
      continue;

    if (op == "render")
    {
      std::string n_tok;
      std::string mode_tok = "auto";
      if (!(iss >> n_tok))
      {
        std::fprintf(stderr, "%s:%d render requires sample count\n", corpus_path.c_str(), line_no);
        return false;
      }
      (void)(iss >> mode_tok);

      int samples = 0;
      if (!parse_int(n_tok, &samples) || samples < 0)
      {
        std::fprintf(stderr, "%s:%d invalid render count\n", corpus_path.c_str(), line_no);
        return false;
      }

      bool mode = *mode32;
      if (mode_tok == "20k")
        mode = false;
      else if (mode_tok == "32k")
        mode = true;

      for (int i = 0; i < samples; i++)
        (void)mcu->generate_next_sample(mode);
    }
    else if (op == "program")
    {
      std::string p_tok;
      int program = 0;
      if (!(iss >> p_tok) || !parse_int(p_tok, &program))
      {
        std::fprintf(stderr, "%s:%d invalid program index\n", corpus_path.c_str(), line_no);
        return false;
      }
      apply_program(mcu, program, mode32);
    }
    else if (op == "raw")
    {
      std::string s0, s1, s2;
      int b0 = 0;
      int b1 = 0;
      int b2 = 0;
      if (!(iss >> s0 >> s1 >> s2) || !parse_int(s0, &b0) || !parse_int(s1, &b1) || !parse_int(s2, &b2))
      {
        std::fprintf(stderr, "%s:%d invalid raw command\n", corpus_path.c_str(), line_no);
        return false;
      }
      mcu->sendMidiCmd(static_cast<uint8_t>(b0 & 0xff), static_cast<uint8_t>(b1 & 0xff), static_cast<uint8_t>(b2 & 0xff));
    }
    else if (op == "note_on" || op == "note_off")
    {
      std::string ch_s, note_s, vel_s;
      int ch = 0;
      int note = 0;
      int vel = 0;
      if (!(iss >> ch_s >> note_s >> vel_s) || !parse_int(ch_s, &ch) || !parse_int(note_s, &note) || !parse_int(vel_s, &vel))
      {
        std::fprintf(stderr, "%s:%d invalid %s\n", corpus_path.c_str(), line_no, op.c_str());
        return false;
      }

      const uint8_t status = static_cast<uint8_t>((op == "note_on" ? 0x90 : 0x80) | (ch & 0x0f));
      mcu->sendMidiCmd(status, static_cast<uint8_t>(note & 0x7f), static_cast<uint8_t>(vel & 0x7f));
    }
    else if (op == "cc")
    {
      std::string ch_s, ctrl_s, val_s;
      int ch = 0;
      int ctrl = 0;
      int val = 0;
      if (!(iss >> ch_s >> ctrl_s >> val_s) || !parse_int(ch_s, &ch) || !parse_int(ctrl_s, &ctrl) || !parse_int(val_s, &val))
      {
        std::fprintf(stderr, "%s:%d invalid cc command\n", corpus_path.c_str(), line_no);
        return false;
      }
      mcu->sendMidiCmd(static_cast<uint8_t>(0xb0 | (ch & 0x0f)), static_cast<uint8_t>(ctrl & 0x7f), static_cast<uint8_t>(val & 0x7f));
    }
    else if (op == "pc")
    {
      std::string ch_s, prog_s;
      int ch = 0;
      int prog = 0;
      if (!(iss >> ch_s >> prog_s) || !parse_int(ch_s, &ch) || !parse_int(prog_s, &prog))
      {
        std::fprintf(stderr, "%s:%d invalid pc command\n", corpus_path.c_str(), line_no);
        return false;
      }
      mcu->sendMidiCmd(static_cast<uint8_t>(0xc0 | (ch & 0x0f)), static_cast<uint8_t>(prog & 0x7f), 0);
    }
    else if (op == "tin")
    {
      std::string state_s;
      int state = 0;
      if (!(iss >> state_s) || !parse_int(state_s, &state))
      {
        std::fprintf(stderr, "%s:%d invalid tin command\n", corpus_path.c_str(), line_no);
        return false;
      }
      mcu->execute_set_input(M6801_TIN_LINE, state ? ASSERT_LINE : CLEAR_LINE);
    }
    else if (op == "irq1")
    {
      std::string state_s;
      int state = 0;
      if (!(iss >> state_s) || !parse_int(state_s, &state))
      {
        std::fprintf(stderr, "%s:%d invalid irq1 command\n", corpus_path.c_str(), line_no);
        return false;
      }
      mcu->execute_set_input(M6800_IRQ_LINE, state ? ASSERT_LINE : CLEAR_LINE);
    }
    else if (op == "run")
    {
      std::string n_tok;
      int n = 0;
      if (!(iss >> n_tok) || !parse_int(n_tok, &n) || n < 0)
      {
        std::fprintf(stderr, "%s:%d invalid run count\n", corpus_path.c_str(), line_no);
        return false;
      }
      for (int i = 0; i < n; i++)
        mcu->execute_run();
    }
    else
    {
      std::fprintf(stderr, "%s:%d unknown op: %s\n", corpus_path.c_str(), line_no, op.c_str());
      return false;
    }
  }

  return true;
}

bool write_lifted_stats(const std::string &path, const Mcu::LiftedStats &stats,
                        const std::vector<u16> &pcs,
                        const std::vector<std::pair<u16, uint64_t>> &pc_hits)
{
  FILE *f = std::fopen(path.c_str(), "wb");
  if (!f)
  {
    std::fprintf(stderr, "failed to open stats output: %s\n", path.c_str());
    return false;
  }

  std::fprintf(f,
               "{"
               "\"step_attempts\":%llu,"
               "\"lifted_steps\":%llu,"
               "\"fallback_steps\":%llu,"
               "\"unlifted_hits\":%llu,"
               "\"unique_unlifted_pcs\":%zu,"
               "\"unlifted_pcs\":[",
               static_cast<unsigned long long>(stats.step_attempts),
               static_cast<unsigned long long>(stats.lifted_steps),
               static_cast<unsigned long long>(stats.fallback_steps),
               static_cast<unsigned long long>(stats.unlifted_hits),
               stats.unique_unlifted_pcs);
  for (size_t i = 0; i < pcs.size(); i++)
  {
    if (i != 0)
      std::fprintf(f, ",");
    std::fprintf(f, "%u", pcs[i]);
  }
  std::fprintf(f, "],\"unlifted_pc_hits\":[");
  for (size_t i = 0; i < pc_hits.size(); i++)
  {
    if (i != 0)
      std::fprintf(f, ",");
    std::fprintf(f, "{\"pc\":%u,\"hits\":%llu}", pc_hits[i].first,
                 static_cast<unsigned long long>(pc_hits[i].second));
  }
  std::fprintf(f, "]}\n");
  std::fclose(f);
  return true;
}

void print_usage(const char *argv0)
{
  std::fprintf(stderr,
               "Usage: %s --runtime <interpreter|lifted> --corpus <file> --out <jsonl> [--stats-out <json>] [--rom-dir <dir>] [--program <0..15>]\n",
               argv0);
}

} // namespace

int main(int argc, char **argv)
{
  CliArgs args;
  if (!parse_cli(argc, argv, &args))
  {
    print_usage(argv[0]);
    return 2;
  }

  RomBlobs roms;
  if (!load_roms(args.rom_dir, &roms))
    return 2;

  ProgramConfig cfg = get_program_config(args.program);
  if (!cfg.rom_set)
  {
    std::fprintf(stderr, "program config missing rom set for index %d\n", args.program);
    return 2;
  }

  Mcu mcu(cfg.rom_set->ic5, cfg.rom_set->ic6, cfg.rom_set->ic7, roms.rd200_b.data(), cfg.rom_set->ic18);
  if (args.runtime == "lifted")
    mcu.setRuntimeMode(Mcu::RuntimeMode::Lifted);
  else
    mcu.setRuntimeMode(Mcu::RuntimeMode::Interpreter);

  FILE *outf = std::fopen(args.out.c_str(), "wb");
  if (!outf)
  {
    std::fprintf(stderr, "failed to open output trace: %s\n", args.out.c_str());
    return 2;
  }

  Rd200JsonlTraceSink trace_sink(outf);
  mcu.setTraceSink(&trace_sink);

  bool mode32 = (cfg.source_sample_rate == 32000);
  apply_program(&mcu, args.program, &mode32);

  const bool ok = run_corpus(&mcu, args.corpus, &mode32);
  std::fclose(outf);

  const Mcu::LiftedStats stats = mcu.getLiftedStats();
  const std::vector<u16> unlifted_pcs = mcu.getLiftedUnliftedPcs();
  const std::vector<std::pair<u16, uint64_t>> unlifted_pc_hits = mcu.getLiftedUnliftedPcHits();
  std::fprintf(stderr,
               "lifted_stats: step_attempts=%llu lifted_steps=%llu fallback_steps=%llu unlifted_hits=%llu unique_unlifted_pcs=%zu\n",
               static_cast<unsigned long long>(stats.step_attempts),
               static_cast<unsigned long long>(stats.lifted_steps),
               static_cast<unsigned long long>(stats.fallback_steps),
               static_cast<unsigned long long>(stats.unlifted_hits),
               stats.unique_unlifted_pcs);

  if (!args.stats_out.empty() && !write_lifted_stats(args.stats_out, stats, unlifted_pcs, unlifted_pc_hits))
    return 2;

  return ok ? 0 : 1;
}
