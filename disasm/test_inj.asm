  .PROCESSOR HD6303
  ORG $E0BB

  LDX   #$1000
  LDD #$4125
    LDX   #$1002
    LDD #$1402
    LDX   #$1004
    LDD #$E07E
    LDX   #$1006
    LDD #$0000
  LDX   #$1010
  LDD #$467B
    LDX   #$1012
    LDD #$1904
    LDX   #$1014
    LDD #$EF76
    LDX   #$1016
    LDD #$0000
  LDX   #$1020
  LDD #$4E6C
    LDX   #$1022
    LDD #$1D06
    LDX   #$1024
    LDD #$E475
    LDX   #$1026
    LDD #$0000
  LDX   #$1030
  LDD #$5143
    LDX   #$1032
    LDD #$2607
    LDX   #$1034
    LDD #$E275
    LDX   #$1036
    LDD #$0000
  LDX   #$1040
  LDD #$4FE2
    LDX   #$1042
    LDD #$2309
    LDX   #$1044
    LDD #$DB74
    LDX   #$1046
    LDD #$0000
  LDX   #$1050
  LDD #$5621
    LDX   #$1052
    LDD #$2D09
    LDX   #$1054
    LDD #$D474
    LDX   #$1056
    LDD #$0000
  LDX   #$1060
  LDD #$143A
    LDX   #$1062
    LDD #$100F
    LDX   #$1064
    LDD #$D173
    LDX   #$1066
    LDD #$0000
  LDX   #$1070
  LDD #$243A
    LDX   #$1072
    LDD #$1010
    LDX   #$1074
    LDD #$BE72
    LDX   #$1076
    LDD #$0000
  LDX   #$1080
  LDD #$298F
    LDX   #$1082
    LDD #$100E
    LDX   #$1084
    LDD #$AD71
    LDX   #$1086
    LDD #$0000
  LDX   #$1090
  LDD #$3582
    LDX   #$1092
    LDD #$100E
    LDX   #$1094
    LDD #$A570
    LDX   #$1096
    LDD #$FF00

  ; LDX   #$1000
  ; LDD   #$E07E
  ; STD   ,X
  ; LDX   #$1006
  ; LDD   #$0000
  ; STD   ,X
LOOP
  BRA   LOOP
