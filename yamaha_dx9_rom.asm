; =============================================================================
; YAMAHA DX9 ROM DISASSEMBLY
; Annotated by AJXS: https://ajxs.me/ https://github.com/ajxs
; =============================================================================

    .PROCESSOR HD6303

    INCLUDE "dasm_includes.asm"

; =============================================================================
; Delay Short Macro.
; Delay by using a BRN instruction targeting the next memory address.
; This is used in numerous places in the DX9 ROM.
; =============================================================================
    .MAC DELAY_SHORT
        BRN     *+2
    .ENDM

; =============================================================================
; Delay Single Macro.
; Emits a single delay cycle.
; =============================================================================
    .MAC DELAY_SINGLE
        PSHX
        PULX
    .ENDM

TIMER_CTRL_EOCI:                                EQU 1 << 3

KEY_SWITCH_SCAN_DRIVER_SOURCE_BUTTONS_2:        EQU %10
KEY_SWITCH_SCAN_DRIVER_SOURCE_PEDALS:           EQU %11
KEY_SWITCH_SCAN_DRIVER_SOURCE_KEYBOARD:         EQU %100

PORT_1_ADC_EOC:                                 EQU 1 << 4
PORT_1_TAPE_REMOTE:                             EQU 1 << 5
PORT_1_TAPE_OUTPUT:                             EQU 1 << 6
PORT_1_TAPE_INPUT:                              EQU 1 << 7

KEY_SWITCH_LINE_0_BUTTON_YES:                   EQU 1
KEY_SWITCH_LINE_0_BUTTON_NO:                    EQU 2
KEY_SWITCH_LINE_0_BUTTON_FUNCTION:              EQU 8

KEY_SWITCH_LINE_1_BUTTON_10:                    EQU 2

; =============================================================================
; These indexes are used as the null-terminating character of the parameter
; name strings.
; The string copy function will return these in ACCB, which is read by the
; menu printing function to determine what function to use to print the
; associated parameter value.
; =============================================================================
PRINT_PARAM_FUNCTION_NUMERIC:                   EQU 1
PRINT_PARAM_FUNCTION_BOOLEAN:                   EQU 2
PRINT_PARAM_FUNCTION_OSC_FREQ:                  EQU 3
PRINT_PARAM_FUNCTION_OSC_DETUNE:                EQU 4
PRINT_PARAM_FUNCTION_KEY_TRANSPOSE:             EQU 5
PRINT_PARAM_FUNCTION_BATTERY_VOLTAGE:           EQU 6
PRINT_PARAM_FUNCTION_MONO_POLY:                 EQU 7
PRINT_PARAM_FUNCTION_PORTAMENTO_MODE:           EQU 8
PRINT_PARAM_FUNCTION_LFO_WAVE:                  EQU 9
PRINT_PARAM_FUNCTION_AVAIL_UNAVAIL:             EQU 10
PRINT_PARAM_FUNCTION_MIDI_CHANNEL:              EQU 11
PRINT_PARAM_FUNCTION_OSC_MODE:                  EQU 12


; =============================================================================
; LCD Constants.
; These are constants related to the HD44780 LCD controller.
; =============================================================================
LCD_CLEAR:                                      EQU 1
LCD_RETURN_HOME:                                EQU 1 << 1

LCD_ENTRY_MODE_SET:                             EQU 1 << 2
LCD_ENTRY_MODE_INCREMENT:                       EQU 1 << 1

LCD_DISPLAY_CONTROL:                            EQU 1 << 3
LCD_DISPLAY_ON:                                 EQU 1 << 2
LCD_DISPLAY_CURSOR:                             EQU 1 << 1
LCD_DISPLAY_BLINK:                              EQU 1

LCD_FUNCTION_SET:                               EQU 1 << 5
LCD_FUNCTION_DATA_LENGTH:                       EQU 1 << 4
LCD_FUNCTION_LINES:                             EQU 1 << 3

LCD_SET_POSITION:                               EQU 1 << 7


ADC_SOURCE_PITCH_BEND:                          EQU 0
ADC_SOURCE_MOD_WHEEL:                           EQU 1
ADC_SOURCE_BREATH_CONTROLLER:                   EQU 2
ADC_SOURCE_SLIDER:                              EQU 3
ADC_SOURCE_BATTERY:                             EQU 4


; =============================================================================
; MIDI Status Codes.
; =============================================================================
MIDI_STATUS_NOTE_OFF:                           EQU $80
MIDI_STATUS_NOTE_ON:                            EQU $90
MIDI_STATUS_MODE_CHANGE:                        EQU $B0
MIDI_STATUS_PROGRAM_CHANGE:                     EQU $C0
MIDI_STATUS_PITCH_BEND:                         EQU $E0
MIDI_STATUS_SYSEX_START:                        EQU $F0
MIDI_STATUS_SYSEX_END:                          EQU $F7
MIDI_STATUS_ACTIVE_SENSING:                     EQU $FE

; =============================================================================
; MIDI SysEx Constants.
; =============================================================================
MIDI_SYSEX_FORMAT_BULK:                         EQU 9
MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE:              EQU $10
MIDI_MANUFACTURER_ID_YAMAHA:                    EQU $43

; =============================================================================
; MIDI CC Constants
; =============================================================================
MIDI_CC_DATA_ENTRY                              EQU 6

; =============================================================================
; Patch Edit Buffer Offsets.
; These offsets can be used to access an individual field inside the patch
; edit buffer, or an unpacked SysEx patch dump.
; =============================================================================
PATCH_OP_EG_RATE_1:                             EQU  0
PATCH_OP_EG_RATE_2:                             EQU  1
PATCH_OP_EG_RATE_3:                             EQU  2
PATCH_OP_EG_RATE_4:                             EQU  3
PATCH_OP_EG_LEVEL_1:                            EQU  4
PATCH_OP_EG_LEVEL_2:                            EQU  5
PATCH_OP_EG_LEVEL_3:                            EQU  6
PATCH_OP_EG_LEVEL_4:                            EQU  7
PATCH_OP_KBD_SCALE_LVL:                         EQU  8
PATCH_OP_KBD_SCALING_RATE:                      EQU  9
PATCH_OP_AMP_MOD_SENSE:                         EQU 10
PATCH_OP_LEVEL:                                 EQU 11
PATCH_OP_FREQ_COARSE:                           EQU 12
PATCH_OP_FREQ_FINE:                             EQU 13
PATCH_OP_DETUNE:                                EQU 14

PATCH_OPERATOR_6:                               EQU  0
PATCH_OPERATOR_5:                               EQU 14
PATCH_OPERATOR_4:                               EQU 28
PATCH_OPERATOR_3:                               EQU 42
PATCH_ALGORITHM:                                EQU 60
PATCH_FEEDBACK:                                 EQU 61
PATCH_OSC_SYNC:                                 EQU 62
PATCH_LFO_SPEED:                                EQU 63
PATCH_LFO_DELAY:                                EQU 64
PATCH_LFO_PITCH_MOD_DEPTH:                      EQU 65
PATCH_LFO_AMP_MOD_DEPTH:                        EQU 66
PATCH_LFO_WAVE:                                 EQU 67
PATCH_LFO_PITCH_MOD_SENS:                       EQU 68
PATCH_KEY_TRANSPOSE:                            EQU 69

PEDAL_INPUT_PORTA:                              EQU 1 << 6
PEDAL_INPUT_SUSTAIN:                            EQU 1 << 7

VOICE_STATUS_SUSTAIN:                           EQU 1
VOICE_STATUS_ACTIVE:                            EQU %10


EGS_VOICE_EVENT_ON:                             EQU 1
EGS_VOICE_EVENT_OFF:                            EQU 2


; =============================================================================
; Raw input button codes.
; These are the codes returned from scanning the front panel input.
; =============================================================================
INPUT_BUTTON_YES:                               EQU 1
INPUT_BUTTON_NO:                                EQU 2
INPUT_BUTTON_STORE:                             EQU 3
INPUT_BUTTON_FUNCTION:                          EQU 4
INPUT_BUTTON_EDIT:                              EQU 5
INPUT_BUTTON_PLAY:                              EQU 7
INPUT_BUTTON_1:                                 EQU 8
INPUT_BUTTON_10:                                EQU 17
INPUT_BUTTON_20:                                EQU 27

BUTTON_EDIT_6:                                  EQU 5
BUTTON_EDIT_7:                                  EQU 6
BUTTON_EDIT_9:                                  EQU 8
BUTTON_EDIT_10:                                 EQU 9
BUTTON_EDIT_11:                                 EQU 10
BUTTON_EDIT_12:                                 EQU 11
BUTTON_EDIT_13:                                 EQU 12
BUTTON_EDIT_14:                                 EQU 13
BUTTON_EDIT_15:                                 EQU 14
BUTTON_EDIT_17:                                 EQU 16
BUTTON_EDIT_20:                                 EQU 19
BUTTON_FUNCTION_1:                              EQU 20
BUTTON_FUNCTION_2:                              EQU 21
BUTTON_FUNCTION_4:                              EQU 23
BUTTON_FUNCTION_5:                              EQU 24
BUTTON_FUNCTION_6:                              EQU 25
BUTTON_FUNCTION_7:                              EQU 26
BUTTON_FUNCTION_10:                             EQU 29
BUTTON_FUNCTION_11:                             EQU 30
BUTTON_FUNCTION_19:                             EQU 38
BUTTON_FUNCTION_20:                             EQU 39
BUTTON_TEST_ENTRY_COMBO:                        EQU 40


EVENT_RELOAD_PATCH:                             EQU 1
EVENT_HALT_VOICES_RELOAD_PATCH:                 EQU 2

; =============================================================================
; UI Modes.
; These codes are used to determine the input mode of the synth's UI.
; =============================================================================
UI_MODE_FUNCTION:                               EQU 0
UI_MODE_EDIT:                                   EQU 1
UI_MODE_PLAY:                                   EQU 2
UI_MODE_UNKNOWN:                                EQU 3

io_port_1_dir:                                  EQU 0
io_port_2_dir:                                  EQU 1
io_port_1_data:                                 EQU 2
io_port_2_data:                                 EQU 3
io_port_4_dir                                   EQU 5
timer_ctrl_status:                              EQU 8
free_running_counter:                           EQU 9
output_compare:                                 EQU $B
rate_mode_ctrl:                                 EQU $10
sci_ctrl_status:                                EQU $11
sci_rx:                                         EQU $12
sci_tx:                                         EQU $13

TIMER_CTRL_EOCI:                                EQU 1 << 3

RATE_MODE_CTRL_CC0:                             EQU 1 << 2
RATE_MODE_CTRL_CC1:                             EQU 1 << 3

SCI_CTRL_TE:                                    EQU 1 << 1
SCI_CTRL_TIE:                                   EQU 1 << 2
SCI_CTRL_RE:                                    EQU 1 << 3
SCI_CTRL_RIE:                                   EQU 1 << 4
SCI_CTRL_TDRE:                                  EQU 1 << 5
SCI_CTRL_ORFE:                                  EQU 1 << 6

; =============================================================================
; MIDI Error codes.
; These constants are used to track the status of the MIDI buffers. If an error
; condition occurs, these constants will be written to the appropriate memory
; location. They are referenced in printing error messages.
; This functionality is identical in the DX7 firmware.
; =============================================================================
MIDI_ERROR_BUFFER_FULL:                         EQU 1
MIDI_ERROR_OVERRUN:                             EQU 2

key_switch_scan_driver_input                    EQU $20

adc_data                                        EQU $22
adc_source                                      EQU $24

ops_mode                                        EQU $26
ops_alg_feedback                                EQU $27

lcd_ctrl:                                       EQU $28
lcd_data:                                       EQU $29

led_1:                                          EQU $2B
led_2:                                          EQU $2C

egs_voice_frequency:                            EQU $1800
egs_operator_frequency:                         EQU $1820
egs_operator_detune:                            EQU $1830
egs_operator_eg_rate:                           EQU $1840
egs_operator_eg_level:                          EQU $1860
egs_operator_level:                             EQU $1880
egs_operator_keyboard_scaling:                  EQU $18E0
egs_amp_mod:                                    EQU $18F0
egs_key_event:                                  EQU $18F1
egs_pitch_mod_high:                             EQU $18F2
egs_pitch_mod_low:                              EQU $18F3


key_switch_scan_input:                          EQU $80
pedal_status_current:                           EQU $84
sustain_status:                                 EQU $85
patch_activate_operator_number:                 EQU $86
patch_activate_operator_offset:                 EQU $87
updated_input_source:                           EQU $88
operator_keyboard_scaling_rate_scaled:          EQU $89
operator_keyboard_scaling_level_scaled:         EQU $8A

; These variables are used in places where the memcpy pointers are already
; used, such as tape patch serialisation routines.
copy_ptr_src:                                   EQU $8B
copy_ptr_dest:                                  EQU $8D
copy_counter:                                   EQU $8F

; When this flag is set the next keypress event will be used to set the
; synth's key transpose.
key_tranpose_set_mode_active:                   EQU $90
note_transpose_frequency_base:                  EQU $91
pedal_status_previous:                          EQU $93
keyboard_last_scanned_values:                   EQU $95

; This variable stores the number of the last incoming note received via MIDI.
; It also stores the last scanned key, and pending key event.
; If this value is 0xFF, it indicates there is no key event pending.
; If bit 7 of this byte is set, it indicates that this note event is a
; 'Key Down' event originating from the keyboard, otherwise it is a 'Key Up'.
note_number:                                    EQU $A1
keyboard_scan_current_key:                      EQU $A2
keyboard_scan_octave:                           EQU $A3

; This is the base logarithmic frequency of the current note, before the
; current pitch EG level is added.
note_frequency:                                 EQU $A4
note_frequency_low:                             EQU $A5

; The index of the selected voice during the 'Note On' subroutine.
; Once a free voice to hold the new note is found, its index is stored here.
note_on_voice_index:                            EQU $A6
egs_load_freq_note_freq:                        EQU $A7
egs_load_freq_voice_number:                     EQU $A9
egs_load_freq_operator_index:                   EQU $AA
tape_byte_counter:                              EQU $AB
tape_input_polarity_previous:                   EQU $AC
tape_input_pilot_tone_counter:                  EQU $AD
tape_input_read_byte:                           EQU $AE
tape_input_delay_length:                        EQU $AF
; This flag is set when a particular tape function is aborted by the user.
tape_function_aborted_flag:                     EQU $B0
portamento_rate_scaled:                         EQU $B1
lfo_phase_increment:                            EQU $B2
lfo_delay_increment:                            EQU $B4
lfo_mod_depth_pitch:                            EQU $B6
lfo_mod_depth_amp:                              EQU $B7
pitch_bend_amount:                              EQU $B8
pitch_bend_frequency:                           EQU $B9
portamento_frequency_base:                      EQU $BB
portamento_process_frequency_increment:         EQU $BD
portamento_process_loop_counter:                EQU $BF
portamento_process_voice_target_frequency:      EQU $C0
lfo_delay_accumulator:                          EQU $C2
; The 'LFO delay fadein factor' variable is used to 'fade in' the LFO
; amplitude after the LFO delay has expired.
lfo_delay_fadein_factor:                        EQU $C4
lfo_phase_accumulator:                          EQU $C6

lfo_sample_and_hold_update_flag:                EQU $C8
lfo_amplitude:                                  EQU $C9
mod_wheel_input_scaled:                         EQU $CA
breath_controller_input_scaled:                 EQU $CB
mod_amount_total:                               EQU $CC
portamento_update_toggle:                       EQU $CD
memcpy_ptr_src:                                 EQU $CE
memcpy_ptr_dest:                                EQU $D0
lcd_print_number_print_zero_flag:               EQU $D2
lcd_print_number_divisor:                       EQU $D3
ui_btn_function_19_patch_init_prompt:           EQU $D4

; Used to track the state of the 'Test Mode' button combination internally.
ui_test_mode_button_combo_state:                EQU $D5

; The synth's current active voice count when in monophonic mode.
active_voice_count:                             EQU $D6

; The synth's current portamento direction.
; * 0: Down.
; * 1: Up.
portamento_direction:                           EQU $D7

porta_current_target_frequency:                 EQU $D8

midi_buffer_ptr_tx_write:                       EQU $D9
midi_buffer_ptr_tx_read:                        EQU $DB
midi_buffer_ptr_rx_write:                       EQU $DD
midi_buffer_ptr_rx_read:                        EQU $DF
midi_last_sent_command:                         EQU $E1
midi_last_command_received:                     EQU $E2
midi_rx_first_data_byte:                        EQU $E3
midi_sysex_substatus:                           EQU $E4
midi_sysex_format_param_grp:                    EQU $E5

; The received SysEx byte count MSB, in the case that the incoming SysEx
; message is data, or the parameter number if it is a parameter change
; message.
midi_sysex_byte_count_msb_param_number:         EQU $E6

; The received SysEx byte count LSB, in the case that the incoming SysEx
; message is data, or the parameter data if it is a parameter change
; message.
midi_sysex_byte_count_lsb_param_data:           EQU $E7
midi_rx_data_count:                             EQU $E8
midi_sysex_tx_checksum:                         EQU $E9
midi_sysex_patch_number:                        EQU $EA
midi_sysex_format_type:                         EQU $EB
midi_sysex_rx_checksum:                         EQU $EC

; The index of the current patch being received during a 32 voice SysEx
; bulk data dump.
midi_sysex_rx_bulk_patch_index:                 EQU $ED
midi_sysex_rx_active_flag:                      EQU $EE
midi_active_sensing_tx_counter:                 EQU $EF
midi_active_sensing_tx_pending_flag:            EQU $F0
midi_sysex_voice_timeout_active:                EQU $F1
midi_active_sensing_rx_counter:                 EQU $F2
midi_sysex_receive_data_active:                 EQU $F3
midi_error_code:                                EQU $F4

    SEG.U ram_external

midi_buffer_tx:                                 EQU $800
midi_buffer_tx_end:                             EQU #midi_buffer_tx + $2AA
midi_buffer_rx:                                 EQU $AAA
midi_buffer_rx_end:                             EQU #midi_buffer_rx + $320
midi_buffer_sysex_tx_single:                    EQU $DCA
midi_buffer_sysex_rx_single:                    EQU $E65
midi_buffer_sysex_tx_bulk:                      EQU $F00
midi_buffer_sysex_rx_bulk:                      EQU $F80
patch_buffer:                                   EQU $1000
patch_buffer_tape_temp:                         EQU $1500
tape_patch_output_counter:                      EQU $1540
tape_patch_checksum:                            EQU $1541
patch_buffer_compare:                           EQU $1543
patch_buffer_edit:                              EQU $1583

patch_edit_operator_4_keyboard_scaling_rate:    EQU #patch_buffer_edit + PATCH_OP_KBD_SCALING_RATE
patch_edit_algorithm:                           EQU #patch_buffer_edit + PATCH_ALGORITHM
patch_edit_feedback:                            EQU #patch_buffer_edit + PATCH_FEEDBACK
patch_edit_oscillator_sync:                     EQU #patch_buffer_edit + PATCH_OSC_SYNC
patch_edit_lfo_speed:                           EQU #patch_buffer_edit + PATCH_LFO_SPEED
patch_edit_lfo_delay:                           EQU #patch_buffer_edit + PATCH_LFO_DELAY
patch_edit_key_transpose:                       EQU #patch_buffer_edit + PATCH_KEY_TRANSPOSE

; This value is used as a 'null' edit parameter.
; When it is selected as the active 'Edit Parameter', any data input will have
; no effect. It is used by the UI subroutines when data input needs to be
; disabled.
null_edit_parameter:                            EQU $15C9

; Unlike the DX7, which stores this variable in a WORD, all use of this
; variable involves shifting it left twice to get its internal value.
master_tune:                                    EQU $15CA
mono_poly:                                      EQU $15CB
pitch_bend_range:                               EQU $15CC

; Portamento Mode:
; Monophonic Mode:
; * 0: Full-time.
; * 1: Fingered.
portamento_mode:                                EQU $15CD
portamento_time:                                EQU $15CE
mod_wheel_range:                                EQU $15CF
mod_wheel_assign:                               EQU $15D0
mod_wheel_amp:                                  EQU $15D1
mod_wheel_eg_bias:                              EQU $15D2
breath_control_range:                           EQU $15D3
breath_control_assign:                          EQU $15D4
breath_control_amp:                             EQU $15D5
breath_control_eg_bias:                         EQU $15D6
midi_rx_channel:                                EQU $15D7
sys_info_avail:                                 EQU $15D8
tape_remote_output_polarity:                    EQU $15D9

; The synth's 'Memory Protect' state.
; When this variable is updated, the memory protection flag bits in the
; 'ui_state' variable are updated, which will prevent any UI operations
; modifying internal memory.
; This variable is referred to independently of the UI state when performing
; tape input operations.
memory_protect:                                 EQU $15DA
tape_input_selected_patch_index:                EQU $15DC
tape_patch_index:                               EQU $15DD
operator_4_enabled_status:                      EQU $15DF
operator_3_enabled_status:                      EQU $15E0
operator_2_enabled_status:                      EQU $15E1
operator_1_enabled_status:                      EQU $15E2
ui_mode_memory_protect_state:                   EQU $15E3
patch_index_current:                            EQU $15E4
ui_btn_numeric_last_pressed:                    EQU $15E5
ui_btn_numeric_previous_fn_mode:                EQU $15E6
ui_btn_numeric_previous_edit_mode:              EQU $15E7
ui_btn_numeric_previous_play_mode:              EQU $15E8
operator_selected_src:                          EQU $15E9
ui_currently_selected_eg_stage:                 EQU $15EA
main_patch_event_flag:                          EQU $15EB
operator_selected_dest:                         EQU $15EC

; Edit mode button 5 sub-function:
; * 0: Algorithm
; * 1: Feedback
ui_btn_edit_5_sub_function:                     EQU $15ED

; Edit mode button 9 sub-function:
; * 0: LFO Amp Mod Depth
; * 1: LFO Pitch ""
ui_btn_edit_9_sub_function:                     EQU $15EE

; Edit mode button 10 sub-function:
; * 0: Amp Mod Sens
; * 1: Pitch ""
ui_btn_edit_10_sub_function:                    EQU $15EF

; Edit mode button 14 sub-function:
; * 0: Detune
; * 1: Oscillator Sync
ui_btn_edit_14_sub_function:                    EQU $15F0

; Function mode button 6 sub-function:
; * 0: MIDI Channel
; * 1: Sys Info
; * 2: MIDI Transmit
ui_btn_function_6_sub_function:                 EQU $15F1

; Function mode button 7 sub-function:
; * 0: Save to tape
; * 1: Verify tape
ui_btn_function_7_sub_function:                 EQU $15F2

; Function mode button 19 sub-function:
; * 0: Edit Recall
; * 1: Voice Init
; * 2: Battery Voltage
ui_btn_function_19_sub_function:                EQU $15F3

; This flag appears to block the mode cycling of button 9 when the synth is
; in 'Edit Mode'.
; It is set when the synth is switched into 'Edit' mode, and is disabled by
; the next press of button 9. So effectively it stops the first press of
; button 9 from cycling the mode.
; The reason this is used is likely so that the user can see which mode is
; selected PRIOR to the mode being cycled.
ui_flag_disable_edit_btn_9_mode_select:         EQU $15F4

; These two variables are used by the user interface to control the currently
; selected 'Edit Parameter', which will be edited by the data input controls.
; The address, and maximum value are loaded from lookup tables in the UI
; routines.
ui_active_param_address:                        EQU $15F5
ui_active_param_max_value:                      EQU $15F7

; This variable is used to store the previously recorded slider input.
; This is used in the slider parameter update routine.
analog_input_slider_previous:                   EQU $15F8

; This flag tracks whether the patch currently loaded into the patch
; edit buffer has been modified.
patch_current_modified_flag:                    EQU $15F9
patch_compare_mode_active:                      EQU $15FA

; This flag appears to disable 'Key Tranpose' UI functionality.
ui_flag_blocks_key_transpose:                   EQU $15FB
lfo_waveform:                                   EQU $15FC
lfo_pitch_mod_sensitivity:                      EQU $15FD
lfo_sample_hold_accumulator:                    EQU $15FE
led_contents:                                   EQU $15FF
led_compare_mode_blink_counter:                 EQU $1601
patch_index_compare:                            EQU $1602
analog_input_source_next:                       EQU $1603
analog_input_previous:                          EQU $1604
analog_input_pitch_bend:                        EQU $1608
analog_input_mod_wheel:                         EQU $1609
analog_input_breath_controller:                 EQU $160A
analog_input_slider:                            EQU $160B
analog_input_battery_voltage:                   EQU $160C
operator_keyboard_scaling_level_curve_table:    EQU $160D
lcd_buffer_current:                             EQU $1681
lcd_buffer_next:                                EQU $16A1
lcd_buffer_next_line_2:                         EQU #lcd_buffer_next + 16
lcd_buffer_next_end:                            EQU #lcd_buffer_next + 32
stack_bottom:                                   EQU $16C1
stack_top:                                      EQU $179F
voice_status:                                   EQU $17A0
voice_frequency_target:                         EQU $17C0
voice_frequency_current:                        EQU $17E0


; In the DX9 firmware, variables used in the test subroutines share
; locations in memory with other variables. Presumably this is because they're
; unused during the diagnostic routines.
test_stage_current:                             EQU $D6
test_stage_sub:                                 EQU $D7
test_stage_sub_2:                               EQU $D8
test_button_input:                              EQU $86


    SEG rom
    ORG $C000

; The 'ROM' diagnostic test performs a checksum of the ROM.
; It loops over each byte in the ROM in 256 byte blocks, adding the value of
; each byte to a total checksum byte. This checksum is expected to add up, with
; integer overflow, to '0'. This byte placed here is the final remainder byte
; that will cause the ROM checksum to total to '0'.
checksum_remainder_byte:
    DC.B 225

; =============================================================================
; HANDLER_RESET
; =============================================================================
; LOCATION: 0xC001
;
; DESCRIPTION:
; Initialises all of the synthesiser's subsystems.
; This routine clears the volatile internal memory, and initialises all of the
; synth's peripheral devices.
;
; =============================================================================
handler_reset:                                  SUBROUTINE
    CLRA
    STAA    <timer_ctrl_status
    LDS     #stack_top

; Set IO Port 4 direction.
; Technically nothing is wired to port 4. This might have been some kind of
; remnant from Yamaha's development system.
    LDAA    #%11111111
    STAA    <io_port_4_dir

; Set Port 1 direction.
; A '1' bit specifies an output line.
; In this case, the input lines are the cassette interface input, and the
; ADC EOC line.
    LDAA    #%1101111
    STAA    <io_port_1_dir

; Set Port 2 direction.
    CLR     io_port_2_dir

; Clear both LEDs.
    CLR     led_1
    CLR     led_2

; Reset the EGS operator volumes.
    JSR     voice_reset_egs_operator_level

; Clear internal RAM.
; Unlike the external RAM, the processor's internal RAM is not powered, and
; thus will not persist when power cycled. In order to ensure a stable
; operating state, this memory is initialised to zero on reset.
    LDX     #key_switch_scan_input
    LDAB    #128
    LDAA    #0

.clear_internal_ram_loop:
    STAA    0,x
    INX
    DECB
    BNE     .clear_internal_ram_loop

; Reset the internal voice frequency buffers.
    JSR     voice_reset_frequency_data

; Store 0xFF in the note number variable to indicate a 'NULL' value.
; This will be intepreted as a no-operation by the note handler in the main
; event loop.
    LDAA    #$FF
    STAA    <note_number
    JSR     midi_init

    JSR     handler_reset_init_peripherals

; Read, and store the battery voltage.
; This is the only point that the battery voltage is actually read.
    LDAA    <adc_data
    DELAY_SINGLE

; Read the battery voltage to ready the system for the initial battery
; voltage check.
    LDAB    #ADC_SOURCE_BATTERY
    JSR     adc_set_source
    JSR     adc_read
    STAA    analog_input_battery_voltage

; Initialise the main system, and user-interface variables.
; This will set the event dispatch flag to reload the patch data to the EGS
; chip, which will be performed in the subsequent subroutine call.
    JSR     handler_reset_system_init
    JSR     main_process_events

; Read the slider input, and store this as the 'initial' previous slider
; input reading. This is necessary so that the next analog input update
; does not immediately trigger a slider input event.
; This would occur because the update compares the current reading against
; the previous to test for a change.
    LDAB    #ADC_SOURCE_SLIDER
    JSR     adc_set_source
    JSR     adc_read
    STAA    analog_input_previous + ADC_SOURCE_SLIDER

; Reset the free-running, and output compare counters.
    LDD     #0
    STD     <free_running_counter
    LDD     #2500
    STD     <output_compare

; Enable the output-compare interrupt, and clear condition flags.
    LDAA    #TIMER_CTRL_EOCI
    STAA    <timer_ctrl_status
    CLRA
    TAP
; Falls-through below to main loop.

; =============================================================================
; MAIN_LOOP
; =============================================================================
; LOCATION: 0xC065
;
; DESCRIPTION:
; Synth firmware executive main loop.
; This is where the bulk of the synth's functionaly is implemented.
; The keyboard, and pedal input are first scanned here. Unlike other Yamaha
; FM synthesisers, the 'Note On', and 'Note Off' functionaliy is implemented
; via a flag set in the keyboard scan routine. This flag records whether a
; key on, or off event has occurred, and which key triggered it. After the
; input scan routine is completed, the 'Note On', and 'Note Off' handlers are
; invoked. which check this flag, and action key events accordingly.
; In the DX7 the keyboard event handling routines are triggered inside the
; main IRQ handler, which reads the physical keyboard input.
;
; =============================================================================
main_loop:
    JSR     main_update_keyboard_and_pedal_input
    JSR     keyboard_note_on_handler
    JSR     keyboard_note_off_handler
    JSR     adc_process
    JSR     main_input_handler
    JSR     main_process_events
    JSR     midi_process_incoming_data
    JSR     main_process_events
; The exact reason for this 'NOP' instruction will never be known, however it
; was likely put here to slightly decrease the polling rate of the synth's
; various peripherals.
    NOP
    BRA     main_loop


; =============================================================================
; MAIN_UPDATE_KEYBOARD_AND_PEDAL_INPUT
; =============================================================================
; LOCATION: 0xC080
;
; DESCRIPTION:
; Updates the peripheral pedal input, and perform the main keyboard scan to
; determine if any keyboard notes have changed.
; The first updated key found will set the 'note_number' global, which is
; processed by the note on, and off handlers in the main loop.
;
; =============================================================================
main_update_keyboard_and_pedal_input:           SUBROUTINE
    JSR     pedals_update

; The function reading pedal input returns the status in ACCB.
; A value of 0 indicates that no change in pedal status has occurred.
; a value of 1 indicates the sustain pedal has changed status, a value of 2
; indicates that the portamento pedal input has changed. The result of the
; change is stored in ACCA.
    TSTB
    BEQ     keyboard_scan

; If this value is 1, it indicates sustain has updated.
; Any other value indicates portamento.
; Send the MIDI 'Mode Change' event accordingly.
    CMPB    #1
    BNE     .portamento_updated

    JSR     midi_tx_pedal_status_sustain
    BRA     keyboard_scan

.portamento_updated:
    JSR     midi_tx_pedal_status_portamento
; Falls-through below.

keyboard_scan:
; The keyboard circuitry is grouped by key, with the same key from each octave
; wired together. The individual keys of an octive are wired to lines 4-15 of
; the key switch scan driver. The value returned is the octave of the pressed
; key (1 << octave).
; This subroutine iterates over the 12 different keys, checking whether each
; read value has changed since the last call.
; If the value read for a key has changed, the value is rotated to find which
; octave changed.
    LDX     #keyboard_last_scanned_values
    LDAB    <io_port_1_data
    ANDB    #%11110000
    ORAB    #KEY_SWITCH_SCAN_DRIVER_SOURCE_KEYBOARD
    STAB    <keyboard_scan_current_key

; Iterate over each key group.
.scan_key_loop:
    LDAB    <keyboard_scan_current_key
    STAB    <io_port_1_data
    DELAY_SINGLE

; Read the status of each octave for this key.
    LDAA    <key_switch_scan_driver_input

; Test if the value has changed since the last check.
    EORA    0,x
    BNE     .key_changed

    INX
    LDAB    <keyboard_scan_current_key
    INCB
    STAB    <keyboard_scan_current_key

; Test if ACCB % 16 is zero.
; ACCB started at 4, so this will loop 12 times (once for each key).
    ANDB    #%1111
    BNE     .scan_key_loop

; If no keys have changed state, set the note number event dispatch
; flag to a null value.
    LDAA    #$FF
    STAA    <note_number
    BRA     .exit

.key_changed:
    LDAB    <keyboard_scan_current_key
    ANDB    #%1111
    CLR     keyboard_scan_octave
    INC     keyboard_scan_octave

.get_updated_octave:
; Rotate this value right until the carry bit is set, indicating that the
; updated octave has been reached.
    RORA
    BCS     .get_updated_keycode

; 12 is added to the key value with each iteration on account of the number
; of keys in an octave. 21 (the base key value) is added to the final value
; to yield the final key code.
    ADDB    #12
    ASL     keyboard_scan_octave
    BRA     .get_updated_octave

.get_updated_keycode:
    ADDB    #21
    STAB    <note_number
    LDAA    <keyboard_scan_octave

; Test whether this key is being pressed. If so, set bit 7.
    BITA    0,x
    BNE     .store_updated_value
    OIMD    #$80, note_number

; Store the updated input.
.store_updated_value:
    EORA    0,x
    STAA    0,x

.exit:
    RTS


; =============================================================================
; MAIN_NOTE_ON_HANDLER
; =============================================================================
; LOCATION: 0xC0DF
;
; DESCRIPTION:
; Handles 'Note On' keyboard events.
; This is called periodically as part of the synth's main executive loop.
; This subroutine is controlled by the main 'Note Number' register. If a
; keyboard 'Key On' event is triggered, the note will be stored in this
; register, and this subroutine will trigger subsequently add the note's
; voice.
;
; ARGUMENTS:
; Memory:
; * note_number: The 'Note On Event' note number.
;    If this value is 0xFF, it indicates there is no key event pending.
;    If bit 7 of this byte is set, it indicates that this note event
;    is a 'Key Up' event originating from the keyboard.
;
; =============================================================================
keyboard_note_on_handler:                       SUBROUTINE
    LDAB    <note_number

; Check whether bit 7 is clear, indicating that the pending key event is a key
; being released. In this case handle it is handled as a 'Key Off' event.
    BPL     .no_action_needed

; Test whether the pending note number is 0xFF, indicating that there is
; no pending note event to handle.
    CMPB    #$FF
    BEQ     .no_action_needed

; Mask the note number.
    ANDB    #%1111111

; Test whether the 'Set Key Tranpose' mode is active.
; In this case the next keypress sets the root note.
    LDAA    <key_tranpose_set_mode_active
    BEQ     .send_midi_message_and_add_new_note

; Test whether the note is below 48.
; If so, set to 48 to initialise the tranpose key at the minimum.
    CMPB    #48
    BMI     .key_under_48

; Clamp the base tranpose key at 72.
    CMPB    #72
    BLS     .set_transpose_key

    LDAB    #72
    BRA     .set_transpose_key

.key_under_48:
    LDAB    #48

.set_transpose_key:
    SUBB    #48
    CMPB    patch_edit_key_transpose
    BEQ     .clear_key_transpose_flag

    STAB    patch_edit_key_transpose

; After the key transpose has been set, send the new value via SysEx.
    JSR     midi_sysex_tx_key_transpose
    JSR     voice_set_key_transpose_base_frequency

; Set the patch edit buffer as having been modified.
    LDAA    #1
    STAA    patch_current_modified_flag
    JSR     ui_print_update_led_and_menu

.clear_key_transpose_flag:
    CLR     key_tranpose_set_mode_active

.no_action_needed:
    JMP     voice_add_exit

.send_midi_message_and_add_new_note:
    JSR     midi_tx_note_on
; Falls-through below.

; ==============================================================================
; VOICE_ADD
; ==============================================================================
; LOCATION: 0xC11C
;
; DESCRIPTION:
; This subroutine is the main entry point to 'adding' a new voice event.
; It is effectively the entry point to actually playing a note over one of the
; synth's voices. This function branches to more specific functions, depending
; on whether the synth is in monophonic, or polyphonic mode.
; This subroutine is where a note keycode is converted to the EGS chip's
; internal representation of pitch. The various voice buffers related to pitch
; transitions are set, and reset here.
;
; ==============================================================================
voice_add:                                      SUBROUTINE
    LDX     #table_midi_key_to_log_f
    ABX

; Convert the key number value shared by the keyboard controller, and
; MIDI input, to the frequency value used internally by the EGS chip.
; The resulting frequency value is represented in logarithmic format, with
; 1024 values per octave.

; The conversion works by using the note number as an index into a lookup
; table, from which the most-significant byte of the pitch is retrieved. The
; lower byte is then created by shifting this value.

; The mechanism used in this subroutine is referenced in patent US4554857:
; "It is known in the art that a frequency number expressed in logarithm can
; be obtained by frequently adding data of two low bits of the key code KC
; to lower bits
; (e.g., Japanese Patent Preliminary Publication No. 142397/1980)."
    LDAA    0,x
    STAA    <note_frequency
    LDAB    #3
    ANDA    #3
    STAA    <note_frequency_low

.get_log_note_frequency_loop:
    ORAA    <note_frequency_low
    ASLA
    ASLA
    DECB
    BNE     .get_log_note_frequency_loop

    STAA    <note_frequency_low
    LDAB    mono_poly
    BEQ     voice_add_poly

    JMP     voice_add_mono

; Loop through the 16 entries in the voice status buffer, testing each
; to find a free voice.
; The voice number offset is not reset each time, and resumes at the same
; place it did in the last 'Note On' event. This variable is initialised on
; device reset.
voice_add_poly:
    LDAA    #16
    LDAB    <note_on_voice_index

; Test the status of each voice to find one that is marked as inactive.
.find_inactive_voice_loop:
    LDX     #voice_status
    ABX
    TIMX    #VOICE_STATUS_ACTIVE, 1,x
    BEQ     .found_inactive_voice

    INCB
    INCB
    ANDB    #%11110
    DECA
    BNE     .find_inactive_voice_loop

; This point is reached if there are no free voices.
    JMP     voice_add_exit

.found_inactive_voice:
; Store ACCB into the 'Buffer Offset' value. This value will be the
; current voice number * 2, used as an offset into the voice buffers.
    STAB    <note_on_voice_index

; Shift the buffer offset value to the left, and add '1' to create the
; bitmask for sending a 'Note Off' event for this voice to the EGS chip.
    INCB
    ASLB
    STAB    egs_key_event

; Store the target frequency for this voice.
    LDD     <note_frequency
    STD     32,x

; The following section tests all of the remaining voices to find another
; one that is inactive. If one is found, the target, and current frequency
; for the second free voice is updated to that of the newly added note.
; This is most likely done to set up the 'next added' note's starting frequency
; for use in portamento. If the synth is in poly mode, the next added note
; will be expected to transition from this note's pitch.

; This loop counter is set to 15, so that the loop will not wrap around to the
; newly added 'Note On' voice.
    LDAA    #15
    LDAB    <note_on_voice_index

.find_second_inactive_voice_loop:
; Increment the voice offset, and perform ACCB % 32 to ensure it doesn't
; exceed the total offset.
    INCB
    INCB
    ANDB    #%11110

; Test if the current voice is active.
    LDX     #voice_status
    ABX
    TIMX    #VOICE_STATUS_ACTIVE, 1,x
    BEQ     .set_second_free_voice_starting_frequency

; Decrement the loop index.
    DECA
    BNE     .find_second_inactive_voice_loop

    BRA     .set_new_voice_status

.set_second_free_voice_starting_frequency:
    LDD     <note_frequency
    STD     32,x
    STD     64,x

.set_new_voice_status:
; Load the previously stored voice number index, and use this as an offset
; into the voice status array.
; Update the voice status, and store the 14-bit frequency for the new note.
    LDX     #voice_status
    LDAB    <note_on_voice_index
    ABX
    LDD     <note_frequency
    ORAB    #VOICE_STATUS_ACTIVE
    STD     0,x

; Reset LFO Delay.
    TST     patch_edit_lfo_delay
    BEQ     .write_frequency_to_egs

    LDD     #0
    STD     <lfo_delay_accumulator
    STD     <lfo_delay_fadein_factor

.write_frequency_to_egs:
; Transform this index variable to the voice number value by shifting right.
    LDAA    <note_on_voice_index
    LSRA

; Write the note frequency, and pitch to the EGS chip.
    LDX     <note_frequency
    JSR     voice_add_load_op_level_voice_freq_to_egs

    LDAA    <note_on_voice_index
    ASLA
    INCA
    STAA    egs_key_event
    LDAB    <note_on_voice_index

; Increment this index value so it is in the most likely position to find
; an available voice in the next 'Note On' event.
    INCB
    INCB
    ANDB    #%11110
    STAB    <note_on_voice_index

voice_add_exit:
    RTS

table_midi_key_to_log_f:
    DC.B 0, 0, 1, 2, 4, 5, 6
    DC.B 8, 9, $A, $C, $D, $E
    DC.B $10, $11, $12, $14, $15
    DC.B $16, $18, $19, $1A, $1C
    DC.B $1D, $1E, $20, $21, $22
    DC.B $24, $25, $26, $28, $29
    DC.B $2A, $2C, $2D, $2E, $30
    DC.B $31, $32, $34, $35, $36
    DC.B $38, $39, $3A, $3C, $3D
    DC.B $3E, $40, $41, $42, $44
    DC.B $45, $46, $48, $49, $4A
    DC.B $4C, $4D, $4E, $50, $51
    DC.B $52, $54, $55, $56, $58
    DC.B $59, $5A, $5C, $5D, $5E
    DC.B $60, $61, $62, $64, $65
    DC.B $66, $68, $69, $6A, $6C
    DC.B $6D, $6E, $70, $71, $72
    DC.B $74, $75, $76, $78, $79
    DC.B $7A, $7C, $7D, $7E, $80
    DC.B $81, $82, $84, $85, $86
    DC.B $88, $89, $8A, $8C, $8D
    DC.B $8E, $90, $91, $92, $94
    DC.B $95, $96, $98, $99, $9A
    DC.B $9C, $9D, $9E, $A0, $A1
    DC.B $A2, $A4, $A5, $A6, $A8


; ==============================================================================
; VOICE_ADD_MONO
; ==============================================================================
; LOCATION: 0xC229
;
; DESCRIPTION:
; This subroutine handes 'adding' a new voice event when the synth is in
; monophonic mode.
; It handles the behaviour of the synth's portamento in monophonic mode.
; If there was already an active note, the portamento direction is updated based
; upon the new note being added.
; If there are already multiple active notes, the portamento target frequency
; is tested to determine whether it needs to be updated based upon the new note
; being played.
;
; ARGUMENTS:
; Memory:
; * note_frequency: The frequency of the new note being added.
;
; ==============================================================================
voice_add_mono:                                 SUBROUTINE
    LDX     #voice_status

    LDAA    <active_voice_count
    BEQ     .setup_new_voice

; Test whether the active voice count is already at the maximum of 16.
; If so, exit.
    CMPA    #16
    BEQ     .exit_no_voice_available

; Since the voice status format in 'Mono' mode clears a voice entry when it
; is not active, test whether the MSB of each entry is 'zero' to determine
; whether it is free.
    LDAB    #16
.find_free_voice_loop:
    TST     0,x
    BEQ     .setup_new_voice

    INX
    INX
    DECB
    BNE     .find_free_voice_loop

.exit_no_voice_available:
; If this point is reached, it means no free voice slot is available.
    RTS

.setup_new_voice:
; Store the 14-bit pitch, and voice status in the free voice status entry.
    LDD     <note_frequency
    ORAB    #VOICE_STATUS_ACTIVE
    STD     0,x

; Reset LFO delay, and LFO fadein.
    TST     patch_edit_lfo_delay
    BEQ     .increment_active_voice_count

    LDD     #0
    STD     <lfo_delay_accumulator
    STD     <lfo_delay_fadein_factor

.increment_active_voice_count:
    LDX     #voice_status
    LDAA    <active_voice_count
    INCA
    STAA    <active_voice_count

; Check if there's more than one voice after incrementing the voice count.
    CMPA    #1
    BNE     .multiple_active_voices

; This section covers the case where no other voice was active when this
; new voice was added.
; @TODO: Unsure why the 'Off' event is sent here.
    LDAA    #EGS_VOICE_EVENT_OFF
    STAA    egs_key_event

; Save the new frequency to the 'Target Voice Frequency' buffer.
    LDD     <note_frequency
    STD     32,x

; Test whether the portamento mode is 'Fingered' or 'Full-Time'.
; If 'Full-Time', don't update the 'Current' frequency, as the previous
; could still be in transition.
    TST     portamento_mode
    BEQ     .write_frequency_to_egs

; Save the new frequency to the 'Current Voice Frequency' buffer.
    STD     64,x

.write_frequency_to_egs:
    CLRA
    LDX     <note_frequency
    JSR     voice_add_load_op_level_voice_freq_to_egs

; Send the 'Voice On' event to the EGS chip.
    LDAA    #EGS_VOICE_EVENT_ON
    STAA    egs_key_event
    RTS

.multiple_active_voices:
; If there's more than one voice after incrementing the voice count,
; check portamento settings.
    CMPA    #2
    BNE     .more_than_two_active_voices

    LDD     <note_frequency
    SUBD    0,x     ; IX = Voice Status.

; If the new note being added is higher than the previous active note, set
; the portamento directon to '1'.
    BCC     .new_note_higher

    CLR     portamento_direction
    BRA     .update_portamento_target_frequency

.new_note_higher:
    LDAA    #1
    STAA    <portamento_direction

.update_portamento_target_frequency:
; Update the voice target frequency, and the portamento target frequency.
    LDD     <note_frequency
    STAA    <porta_current_target_frequency
    STD     32,x
    RTS

.more_than_two_active_voices:
; The current section handles the case that there are more than two active
; voices after incrementing the voice count.

; Test the portamento direction. Branch if 'downwards'.
; Test the portamento direction, and the target frequency to determine
; whether the newly added note overrides the previous target frequency.
    LDAA    <portamento_direction
    BEQ     .portamento_direction_downward

    LDAA    <note_frequency
    SUBA    <porta_current_target_frequency

; If the carry bit is set, it indicates that the current portamento target
; frequency is higher than the new note. In this case, don't update the
; portamento target frequency.
    BCS     .portamento_target_frequency_not_updated

    BRA     .update_portamento_target_frequency

.portamento_direction_downward:
    LDAA    <note_frequency
    SUBA    <porta_current_target_frequency

; If the carry bit is clear, it indicates that the current portamento target
; frequency is lower than the new note. In this case, don't update the
; portamento target frequency.
    BCC     .portamento_target_frequency_not_updated

    BRA     .update_portamento_target_frequency

.portamento_target_frequency_not_updated:
; If this is reached, it indicates that (based upon the portamento direction)
; the new note should not be set as the new portamento target because it is
; either not higher, or lower than the current target.
    RTS


; =============================================================================
; MAIN_NOTE_OFF_HANDLER
; =============================================================================
; LOCATION: 0xC2A9
;
; DESCRIPTION:
; Handles 'Note Off' keyboard events.
; This is called periodically as part of the synth's main executive loop.
; This subroutine is controlled by the main 'Note Number' register. If a
; keyboard 'Key Off' event is triggered, the note will be stored in this
; register, and this subroutine will trigger subsequently remove the note's
; voice.
;
; ARGUMENTS:
; Memory:
; * note_number: The 'Note Off Event' note number.
;    If this value is 0xFF, it indicates there is no key event pending.
;    If bit 7 of this byte is set, it indicates that this note event
;    is a 'Key Up' event originating from the keyboard.
;
; =============================================================================
keyboard_note_off_handler:                      SUBROUTINE
    LDAB    <note_number

; Check whether bit 7 is set, indicating the key is being pressed.
; Bit 7 being clear indicates the key has been released.
    BMI     voice_remove_poly_exit

; Send the MIDI 'Note Off' event.
    JSR     midi_tx_note_off
; Falls-through below to voice_remove.

voice_remove:                                   SUBROUTINE
    LDX     #table_midi_key_to_log_f
    ABX

; Since the voice status array entries are stored as words with the 14-bit
; pitch stored together with the voice status, it's possible to use only
; the most-significant byte of the pitch to find the correct voice.
    LDAA    0,x

; Is the synth in mono?
; Branch if poly.
    LDAB    mono_poly
    BEQ     voice_remove_poly

    JMP     voice_remove_mono

voice_remove_poly:
    LDAB    #EGS_VOICE_EVENT_OFF
    LDX     #voice_status

.find_key_event_loop:
; Check whether the MSB of the current voice's frequency is equal to the
; frequency being removed, indicating that this is the voice being stopped.
    CMPA    0,x
    BNE     .increment_loop_pointers

; Test whether the voice being stopped is currently active.
    TIMX    #VOICE_STATUS_ACTIVE, 1,x
    BNE     .is_voice_sustained

.increment_loop_pointers:
; Increment the loop pointers, and voice number, then loop back.
    INX
    INX

; The value in ACCB corresponds to the EGS 'Voice Event' field.
; Since the voice number is stored in fields 2-5, incrementing the index
; by 4 will increment the voice number field by one.
    ADDB    #4

; Test whether we're at iteration 16 by checking whether this value is
; above 64. This is done because the bit corresponding to
; 'EGS Voice Event Off' was previous set.
    BITB    #64
    BEQ     .find_key_event_loop

; If this point has been reached, an active voice with the specified
; frequency cannot be found.
    BRA     voice_remove_poly_exit

.is_voice_sustained:
; Now that the voice has been found, test whether the sustain pedal is
; currently active. If so, the voice itself will be set inactive, but the
; voice will stay in its sustain phase.
    TIMD    #PEDAL_INPUT_SUSTAIN, sustain_status
    BNE     .voice_sustained

; If sustain is not active, deactivate the voice, and store the voice
; event deactivating the voice to the EGS chip.
    AIMX    #~VOICE_STATUS_ACTIVE, 1,x
    STAB    egs_key_event
    BRA     voice_remove_poly_exit

.voice_sustained:
; Since the sustain pedal is depressed, set the voice status bit indicating
; that the voice is sustained, and reset the bit indicating it is active.
    OIMX    #VOICE_STATUS_SUSTAIN, 1,x
    AIMX    #~VOICE_STATUS_ACTIVE, 1,x

voice_remove_poly_exit:
    RTS

voice_remove_mono:                              SUBROUTINE
; Branch, and exit in the case that the voice count is zero, or less.
    TST     active_voice_count
    BLE     voice_remove_mono_exit_not_removed

    STAA    <note_frequency
    JSR     voice_remove_mono_get_active_voice

; The carry flag being set indicates a failure condition: That a voice
; with the specified note frequency cannot be found.
    BCS     voice_remove_mono_exit_not_removed

    DEC     active_voice_count
    BNE     .deactivate_voice

; Now that the voice has been found, test whether the sustain pedal is
; currently active. If so, the voice itself will be set inactive, but the
; voice will stay in its sustain phase.
    LDX     #voice_status
    TST     sustain_status
    BMI     .voice_sustained

    AIMX    #~VOICE_STATUS_ACTIVE, 1,x
    LDAB    #2
    STAB    egs_key_event
    BRA     voice_remove_mono_exit_not_removed

.voice_sustained:
; Since the sustain pedal is depressed, set the voice status bit indicating
; that the voice is sustained, and reset the bit indicating it is active.
    OIMX    #VOICE_STATUS_SUSTAIN, 1,x
    AIMX    #~VOICE_STATUS_ACTIVE, 1,x

voice_remove_mono_exit_not_removed:
    RTS

.deactivate_voice:
    LDD     #0
    STD     0,x
    JSR     voice_remove_mono_get_porta_target_note

; Store the new target frequency, and mask the lowest two bits.
    STD     <note_frequency
    ANDB    #%11111100
    STD     voice_frequency_target

; If the decremented voice count is now equal to '1', clear the current
; highest voice, and set voice#0 to the target frequency.
    LDAA    <active_voice_count
    CMPA    #1
    BNE     voice_remove_mono_exit

    LDD     #0
    STD     0,x
    LDD     <note_frequency
    STD     voice_status

voice_remove_mono_exit:
    RTS


; =============================================================================
; VOICE_REMOVE_MONO_GET_ACTIVE_VOICE
; =============================================================================
; LOCATION: 0xC334
;
; DESCRIPTION:
; Searches through the voice status array to find a currently active voice
; matching the frequency specified.
;
; ARGUMENTS:
; Memory:
; * note_frequency: The frequency to search for.
;
; RETURNS:
; * IX: A pointer to the index of the voice status entry matching the
;    specified frequency.
;    The carry flag is set to indicate the failur condition of not being
;    able to find the matching voice.
;
; =============================================================================
voice_remove_mono_get_active_voice:             SUBROUTINE
    LDAB    #16
    LDX     #voice_status

.find_voice_loop:
    LDAA    0,x
    CMPA    <note_frequency
    BEQ     .exit

    INX
    INX
    DECB
    BNE     .find_voice_loop

; If the loop reaches zero without finding the active voice with the
; specified note, set the carry flag to indicate a failure condition.
    SEC

.exit:
    RTS


; =============================================================================
; VOICE_REMOVE_MONO_GET_PORTA_TARGET_NOTE
; =============================================================================
; LOCATION: 0xC346
;
; DESCRIPTION:
; Based upon the portamento direction, and the current portamento target
; frequency, finds the next target frequency. This is used when removing a
; currently playing note in mono mode.
;
; RETURNS:
; * ACCD: The value of the voice status entry of the next portamento target.
;
; =============================================================================
voice_remove_mono_get_porta_target_note:        SUBROUTINE
    CLRB
    LDX     #voice_status
    CLR     porta_current_target_frequency

; If porta direction is down, set the current target value to 0xFF, so
; that it is easy to compare if the next found value is lower.
    TST     portamento_direction
    BNE     .voice_remove_mono_get_porta_target_note_loop

    COM     porta_current_target_frequency

; Based upon the portamento direction, loop over each of the 16 voices,
; testing which note should be the next target. If the direction of
; portamento is 'down', find the lowest note, otherwise find the highest.
.voice_remove_mono_get_porta_target_note_loop:
; If inactive, advance to the next entry.
    LDAA    0,x
    BEQ     .voice_remove_mono_get_porta_target_note_loop_advance
    TST     portamento_direction

; Branch if porta direction is 'down'.
    BEQ     .voice_remove_mono_get_porta_target_note_lower

; if the current highest is higher than this note, advance the loop.
    CMPA    <porta_current_target_frequency
    BCS     .voice_remove_mono_get_porta_target_note_loop_advance

    BRA     .voice_remove_mono_set_porta_target_note

.voice_remove_mono_get_porta_target_note_lower:
    CMPA    <porta_current_target_frequency

; If the current lowest is lower than this note, advance the loop.
    BHI     .voice_remove_mono_get_porta_target_note_loop_advance

.voice_remove_mono_set_porta_target_note:
    STAA    <porta_current_target_frequency
    STAB    <copy_counter

.voice_remove_mono_get_porta_target_note_loop_advance:
    INX
    INX
    INCB
    CMPB    #16
    BNE     .voice_remove_mono_get_porta_target_note_loop

    LDX     #voice_status
    LDAB    <copy_counter
    ASLB
    ABX
    LDD     0,x

    RTS


; =============================================================================
; ADC_PROCESS
; =============================================================================
; LOCATION: 0xC37D
;
; DESCRIPTION:
; Processes the synth's analog input.
; This subroutine will process the currently selected analog input source,
; sending a MIDI event as necessary if the input was updated.
; The input source is then decremented, so the next invocation will update
; the next input source.
; Note: This subroutine does not periodically scan the battery voltage.
;
; ARGUMENTS:
; Memory:
; * analog_input_source_next: The 'next' A/D input source to scan. This source
;    number will be incremented by the operation.
;
; =============================================================================
adc_process:                                    SUBROUTINE
; Update the specified 'next' input source.
    LDAB    analog_input_source_next
    JSR     adc_update_input_source

; The CPU carry-flag being set indicates that the value is unchanged.
    BCS     .update_next_input_source

; Test whether the input source number is zero, which would indicate that
; it is a pitch bend event.
    TSTB
    BNE     .test_if_slider_event

; If this is a pitch-bend event, send a corresponding MIDI event.
    JSR     midi_tx_pitch_bend
    BRA     .reload_and_update_next_input_source

; This code matches the code in the DX7 v1.8 ROM at 0xEAE3.
.test_if_slider_event:
    CMPB    #ADC_SOURCE_SLIDER
    BNE     .send_midi_cc_message
    LDAB    #MIDI_CC_DATA_ENTRY

.send_midi_cc_message:
; If this is not a pitch-bend event, send a generic analog input event
; via MIDI.
    JSR     midi_tx_analog_input_event

.reload_and_update_next_input_source:
    LDAB    analog_input_source_next

.update_next_input_source:
; The source value cycles 3-2-1-0.
; This is facilitated by decrementing the value until it underflows,
; then masking it to 0b11.
    DECB
    ANDB    #%11
    STAB    analog_input_source_next
    JSR     adc_set_source
    RTS


; =============================================================================
; MAIN_INPUT_HANDLER
; =============================================================================
; LOCATION: 0xC3A3
;
; DESCRIPTION:
; This is the entry point for the synth's input handling.
; This is where the synth's analog front-panel input is read, and acted upon.
; The subroutine is called from the main loop, and the source of the last
; input event is used as an index into a switch table, which initiates the
; synth's main UI functionality.
;
; @TODO: Figure out how it's handled when nothing is pressed?
; Potentially this just defaults to the slider.
;
; =============================================================================
main_input_handler:                             SUBROUTINE
    CLR     main_patch_event_flag
    JSR     input_read_front_panel
; Falls-through below.

; =============================================================================
; MAIN_INPUT_HANDLER_PROCESS_BUTTON
; =============================================================================
; LOCATION: 0xC3A9
;
; DESCRIPTION:
; Processes an individual front-panel button press.
; This subroutine is called from various places to arbitrarily process an
; individual front panel button press.
;
; ARGUMENTS:
; Registers:
; * ACCB: The front-panel button code.
;
; =============================================================================
main_input_handler_process_button:              SUBROUTINE
; Is the last analog event code below 3? If so, branch.
; This indicates it's either a slider, or Yes/No button event.
    CMPB    #INPUT_BUTTON_STORE
    BCS     main_input_handler_dispatch

; If any key other than the data input slider, or 'Yes/No' are pressed
; clear the key transpose mode flag.
    CLR     key_tranpose_set_mode_active
    CLR     ui_flag_blocks_key_transpose
; Falls-through below.

; =============================================================================
; MAIN_INPUT_HANDLER_DISPATCH
; =============================================================================
; DESCRIPTION:
; This is the main jumpoff where the different front-panel button
; functionality is initiated, based upon the UI input mode.
;
; ARGUMENTS:
; Registers:
; * ACCB: The front-panel button code.
;
; =============================================================================
main_input_handler_dispatch:                    SUBROUTINE
; This is the main jumpoff where the different front-panel button
; functionality is initiated, based upon the UI input mode.
    LDAA    ui_mode_memory_protect_state
    JSR     jumpoff

    DC.B input_slider - *
    DC.B 1
    DC.B input_button_yes_no - *
    DC.B 3
    DC.B input_button_main - *
    DC.B 8
    DC.B input_button_numeric - *
    DC.B 0


; =============================================================================
; INPUT_SLIDER
; =============================================================================
; LOCATION: 0xC3C1
;
; DESCRIPTION:
; The main input handler for the front-panel 'Data Entry' slider.
;
; ARGUMENTS:
; Registers:
; * ACCA: The UI Input Mode.
; * ACCB: The triggering front-panel input code.
;
; =============================================================================
input_slider:                                   SUBROUTINE
    ANDA    #%1100

; Check if the current UI sate is function/edit/play?
; If not, exit.
; @TODO: Verify this.
    BNE     main_input_handler_exit

    JSR     ui_input_slider
    TST     main_patch_event_flag
    BNE     input_update_led_and_menu

    BRA     main_input_handler_exit


; =============================================================================
; INPUT_BUTTON_YES_NO
; =============================================================================
; LOCATION: 0xC3CF
;
; DESCRIPTION:
; The main input handler for when the front-panel 'Yes', or 'No' buttons are
; pressed.
;
; ARGUMENTS:
; Registers:
; * ACCA: The UI Input Mode.
; * ACCB: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
input_button_yes_no:                            SUBROUTINE
; Check if the current UI sate is in 'Store' mode. If so, exit.
    ANDA    #%1100
    BNE     main_input_handler_exit

; The following subroutine call sets the carry-bit to indicate that the
; corresponding UI menu item is a 'Yes/No' prompt, as opposed to representing a
; numeric value that can be incremented, or decremented.
; This will cause a jump to update the LED, print the menu, and exit.
; Otherwise it will continue to process incrementing, or decrementing the
; currently selected parameter.
    JSR     ui_yes_no
    BCS     input_update_led_and_menu

    JSR     ui_input_decrement
    BRA     input_update_led_and_menu


; =============================================================================
; INPUT_BUTTON_MAIN
; =============================================================================
; LOCATION: 0xC3DD
;
; DESCRIPTION:
; Handles a 'main' front-panel button being pressed.
; These buttons are the main non-numeric, non data-entry buttons.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode.
; * ACCB: The analog input code passed from the main input handler routine.
;         This represents the source of the last front-panel input.
;         This will be converted to a relative value representing the last
;         'main' button pressed, and used as an input to a switch table.
;         These values are:
;          - 0: "STORE"
;          - 1: ???
;          - 2: "FUNCTION"
;          - 3: "EDIT"
;          - 4: "MEMORY "
; =============================================================================
input_button_main:                              SUBROUTINE
    SUBB    #3

; 3 is subtracted from the input source code on account of the 'main'
; front-panel buttons starting at index 3.
    JSR     ui_button_main
    BRA     input_update_led_and_menu


; =============================================================================
; INPUT_BUTTON_NUMERIC
; =============================================================================
; LOCATION: 0xC3E4
;
; DESCRIPTION:
; Main input handler function for when the triggering front-panel button press
; is one of the numeric buttons (1-20).
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel switch number.
;
; =============================================================================
input_button_numeric:                           SUBROUTINE
; Subtract 8, since the numeric buttons start at 8.
    SUBB    #8
    CMPA    #10

; If ACCA >= 10, clear.
    BCS     .jumpoff

    CLRA

.jumpoff:
    JSR     jumpoff_indexed_from_acca

; =============================================================================
; Numeric Button Handler Functions.
; =============================================================================
    DC.B input_button_numeric_function_mode - *
    DC.B input_button_numeric_edit_mode - *
    DC.B input_button_numeric_play_mode - *
    DC.B input_update_led_and_menu - *

; =============================================================================
; Numeric Button Handler Functions: Memory Protect Disabled.
; =============================================================================
    DC.B input_update_led_and_menu - *
    DC.B input_button_numeric_eg_copy_mode - *
    DC.B input_button_numeric_store_mode - *
    DC.B input_update_led_and_menu - *

; =============================================================================
; Numeric Button Handler Functions: Memory Protect Enabled.
; =============================================================================
    DC.B input_update_led_and_menu - *
    DC.B input_button_numeric_eg_copy_mode - *


; =============================================================================
; INPUT_BUTTON_NUMERIC_FUNCTION_MODE
; =============================================================================
; LOCATION: 0xC3F8
;
; DESCRIPTION:
; Handles a front-panel numeric button press while the synth's user-interface
; is in 'Function Mode'.
; This function adds '20' to the button number, since the 'Function Mode'
; button codes start after the 'Edit Mode' button codes (0-19).
; This function then calls the main UI numeric button handler, which triggers
; the specific functionality associated with the assigned button code.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel numeric switch number, starting at index 0.
;         '20' is added to this number to properly index the function mode
;         front-panel buttons.
;
; =============================================================================
input_button_numeric_function_mode:             SUBROUTINE
    ADDB    #20
; Falls-through below.

; =============================================================================
; INPUT_BUTTON_NUMERIC_EDIT_MODE
; =============================================================================
; LOCATION: 0xC3FA
;
; DESCRIPTION:
; Handles a front-panel numeric button press while the synth's user-interface
; is in 'Edit Mode'.
; This function then calls the main UI numeric button handler, which triggers
; the specific functionality associated with the assigned button code.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel numeric switch number, starting at index 0.
;
; =============================================================================
input_button_numeric_edit_mode:                 SUBROUTINE
    JSR     ui_button_numeric
    BRA     input_update_led_and_menu


; =============================================================================
; INPUT_BUTTON_NUMERIC_PLAY_MODE
; =============================================================================
; LOCATION: 0xC3FF
;
; DESCRIPTION:
; Handles a front-panel numeric button press while the synth's user-interface
; is in 'Play Mode'. Specifically this means 'Memory Select' mode while
; 'Memory Protect' is enabled.
; Initiates loading a patch from a front-panel numeric button press.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel numeric switch number, starting at index 0.
;
; =============================================================================
input_button_numeric_play_mode:                 SUBROUTINE
    JSR     patch_load
    BRA     input_update_led_and_menu


; =============================================================================
; INPUT_BUTTON_NUMERIC_EG_COPY_MODE
; =============================================================================
; LOCATION: 0xC404
;
; DESCRIPTION:
; Handles a front-panel numeric button press while the synth's user-interface
; is in 'EG Copy Mode'. Specifically this means 'Edit' mode while the memory
; protect bits are set in the UI mode.
; Initiates copying an operator's EG settings from a front-panel numeric
; button press.
;
; ARGUMENTS:
; Registers:
; * ACCB: Front-panel numeric switch number, starting at index 0.
;
; =============================================================================
input_button_numeric_eg_copy_mode:              SUBROUTINE
    JSR     patch_operator_eg_copy
    BRA     input_update_led_and_menu


; =============================================================================
; INPUT_BUTTON_NUMERIC_STORE_MODE
; =============================================================================
; LOCATION: 0xC409
;
; DESCRIPTION:
; Handles a front-panel numeric button press while the synth's user-interface
; is in 'Store Mode'. Specifically this means 'Memory Select' mode while
; 'Memory Protect' is disabled.
; Initiates saving a patch from a front-panel numeric button press. The number
; of the key pressed will be passed as the index to save the patch to.
;
; ARGUMENTS:
; Registers:
; * ACCB: Front-panel numeric switch number, starting at index 0.
;
; =============================================================================
input_button_numeric_store_mode:                SUBROUTINE
    JSR     patch_save
; Falls-through below.

; =============================================================================
; INPUT_UPDATE_LED_AND_MENU
; =============================================================================
; LOCATION: 0xC40C
;
; DESCRIPTION:
; This call serves as the exit point for many subroutines.
; It updates the LED, and prints the menu.
;
; =============================================================================
input_update_led_and_menu:                      SUBROUTINE
    JSR     ui_print_update_led_and_menu
; Falls-through below.

main_input_handler_exit:
    RTS


; =============================================================================
; MAIN_PROCESS_EVENTS
; =============================================================================
; LOCATION: 0xC410
;
; DESCRIPTION:
; This subroutine processes some of the synth's periodic events, as well as
; triggering the reloading of patch data to the voice chips based upon the
; value of an event dispatch flag variable
;
; MEMORY USED:
; * main_patch_event_flag: This is used as an event dispatch flag.
;           Depending on the value set, it will either cause the patch data
;           to be reloaded to the EGS/OPS, or the data reloaded and all
;           active voices halted.
;
; =============================================================================
main_process_events:                            SUBROUTINE
    LDAA    main_patch_event_flag
    BEQ     .send_remote_signal

    CMPA    #EVENT_RELOAD_PATCH
    BEQ     .reload_patch

    JSR     voice_reset_egs

.reload_patch:
    JSR     patch_activate

.send_remote_signal:
; I'm not sure why the tape remote signal is set here in the main loop.
; Is this because reading the ADC disrupts the status of the output lines?
    JSR     tape_remote_output_signal

    TST     midi_active_sensing_tx_pending_flag
    BNE     .exit

    JSR     midi_tx_active_sensing
    LDAA    #$FF
    STAA    <midi_active_sensing_tx_pending_flag

.exit:
    RTS


; =============================================================================
; MIDI_PROCESS_INCOMING_DATA
; =============================================================================
; LOCATION: 0xC42F
;
; DESCRIPTION:
; Processes the incoming MIDI messages stored in the MIDI RX buffer.
; This subroutine is called by the synthesizer's main loop.
; All of the synth's incoming MIDI functionality is initiated in this function.
;
; =============================================================================
midi_process_incoming_data:                     SUBROUTINE
; Has a MIDI error occurred?
    TST     midi_error_code
    BEQ     .is_queue_empty

    JSR     midi_print_error_message
    BRA     .reset_and_exit

.is_queue_empty:
; Test whether the MIDI RX ring buffer read, and write pointers are equal,
; indicating that the MIDI RX buffer is empty.
; If not, proceed to processing the incoming MIDI data.
    LDX     <midi_buffer_ptr_rx_read
    CPX     <midi_buffer_ptr_rx_write
    BNE     .process_incoming_data

    LDAA    <midi_sysex_rx_active_flag
    CMPA    #1
    BCS     .reset_and_exit

    CLR     midi_sysex_rx_active_flag
    JSR     midi_reenable_timer_interrupt
    BRA     .reset_and_exit

.process_incoming_data:
; Is the current read pointer address the last address in the RX buffer?
; If so, reset it to the last address BEFORE the RX buffer, so that the
; increment operation resets the buffer.
    LDAA    0,x
    CPX     #midi_buffer_rx_end - 1
    BNE     .update_rx_pointer

    LDX     #midi_buffer_rx - 1

.update_rx_pointer:
; Store the updated MIDI RX buffer read pointer.
    INX
    STX     <midi_buffer_ptr_rx_read

; Test the incoming MIDI message to determine whether it's a data, or
; status byte. Bit 7 being set indicates that this is a status byte.
    TSTA
    BPL     .process_data_message

; Is the MIDI status code above 0xF7?
; If so, ignore.
    CMPA    #MIDI_STATUS_SYSEX_END
    BCC     .reset_and_exit

; Store the message type, and reset the received data count.
; Proceed to process the next incoming message in the buffer.
    STAA    <midi_last_command_received
    CLR     midi_rx_data_count
    BRA     midi_process_incoming_data

.process_data_message:
    LDAB    <midi_last_command_received
    CMPB    #MIDI_STATUS_SYSEX_START

; Check whether the status is under 0xF0. If so, branch.
    BCS     .test_command_midi_channel

; If the status code is higher than 0xF0, ignore.
; Proceed to process the next incoming message in the buffer.
    BHI     midi_process_incoming_data

    JMP     midi_sysex_rx

; Mask the MIDI channel in the status byte.
; Exit if this message is not intended for this device.

.test_command_midi_channel:
    ANDB    #%1111
    CMPB    midi_rx_channel
    BNE     .reset_and_exit

; Handle all regular MIDI commands (Note On/Off, Program Change, Control Code, etc.)
; Shift and mask the MIDI event type to make it suitable for the jumpoff
; table format.
    LDAB    <midi_last_command_received
    LSRB
    LSRB
    LSRB
    LSRB
    ANDB    #%111
    JSR     jumpoff

    DC.B midi_rx_note_off - *
    DC.B 1
    DC.B midi_rx_note_on - *
    DC.B 2
    DC.B .reset_and_exit - *
    DC.B 3
    DC.B midi_rx_control_code - *
    DC.B 4
    DC.B midi_rx_program_change - *
    DC.B 5
    DC.B .reset_and_exit - *
    DC.B 6
    DC.B midi_rx_pitch_bend - *
    DC.B 7
    DC.B .reset_and_exit - *
    DC.B 0

.reset_and_exit:
    RTS


; =============================================================================
; MIDI_RX_NOTE_OFF
; =============================================================================
; LOCATION: 0xC496
;
; DESCRIPTION:
; Handles incoming MIDI data when the pending MIDI event is a 'Note Off' event.
; If the incoming data is the first of the two required bytes, this function
; will store the incoming MIDI data, and jump back to process any further
; incoming MIDI data.
; If both bytes have been received, the internal 'Note Number' event dispatch
; register will be set with the incoming MIDI data, which will trigger a
; 'Voice Remove' event with the requested note.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_note_off:                               SUBROUTINE
; Test if the number of data bytes received already is non-zero.
; If so, all the necessary data had now been received. Proceed to processing
; the MIDI event.
; Otherwise, store the incoming byte and proceed to process the next
; incoming MIDI data messages.
    TST     midi_rx_data_count
    BNE     .midi_rx_note_off_complete

    INC     midi_rx_data_count
    STAA    <midi_rx_first_data_byte
    JMP     midi_process_incoming_data

.midi_rx_note_off_complete:
    CLR     midi_rx_data_count

midi_rx_note_off_process:
    LDAB    <midi_rx_first_data_byte
    STAB    <note_number
    JSR     voice_remove

    RTS


; =============================================================================
; MIDI_RX_NOTE_ON
; =============================================================================
; LOCATION: 0xC4AE
;
; DESCRIPTION:
; Handles incoming MIDI data when the pending MIDI event is a 'Note On' event.
; If the incoming data is the first of the two required bytes, this function
; will store the incoming MIDI data, and jump back to process any further
; incoming MIDI data.
; If both bytes have been received, the internal 'Note Number' event dispatch
; register will be set with the incoming MIDI data, which will trigger a
; 'Voice Add' event with the requested note.
; If the velocity of the incoming MIDI event is zero, then the MIDI event will
; be handled by the synth as a 'Note Off' event.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_note_on:                                SUBROUTINE
; Test if the number of data bytes received already is non-zero.
; If so, all the necessary data had now been received. Proceed to processing
; the MIDI event.
; Otherwise, store the incoming byte and proceed to process the next
; incoming MIDI data messages.
    TST     midi_rx_data_count
    BNE     .midi_rx_note_on_complete

    INC     midi_rx_data_count
    STAA    <midi_rx_first_data_byte
    JMP     midi_process_incoming_data

.midi_rx_note_on_complete:
    CLR     midi_rx_data_count

; Check if velocity is zero.
; If so, process as 'Note Off' event.
    TSTA
    BEQ     midi_rx_note_off_process

    LDAB    <midi_rx_first_data_byte
    STAB    <note_number
    JSR     voice_add

    RTS


; =============================================================================
; MIDI_RX_PITCH_BEND
; =============================================================================
; LOCATION: 0xC4C9
;
; DESCRIPTION:
; Handles incoming MIDI data when the pending MIDI event is a
; 'Pitch Bend' event.
; If the incoming data is the first of the two required bytes, this function
; will store the incoming MIDI data, and jump back to process any further
; incoming MIDI data.
; If both bytes have been received, the internal register for storing the
; analog pitch bend data will be updated with the MSB of the incoming data.
;
; A MIDI pitch bend event is transmitted as three bytes, the status byte,
; and two data bytes.
; Refer to this resource for more information on the structure of a
; MIDI pitch-bend event:
; https://sites.uci.edu/camp2014/2014/04/30/managing-midi-pitchbend-messages/
;
; Like many other synths, the DX7/9 only use the MSB of the pitch-bend data
; standard internally.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_pitch_bend:                             SUBROUTINE
; Test if the number of data bytes received already is non-zero.
; If so, all the necessary data had now been received. Proceed to processing
; the MIDI event.
; Otherwise, store the incoming byte and proceed to process the next
; incoming MIDI data messages.
    TST     midi_rx_data_count
    BNE     .midi_rx_pitch_bend_complete

    INC     midi_rx_data_count
    JMP     midi_process_incoming_data

.midi_rx_pitch_bend_complete:
    CLR     midi_rx_data_count

; Only take the MSB, discard the 2nd data byte with the LSB.
    ASLA
    STAA    analog_input_pitch_bend

    RTS


; =============================================================================
; MIDI_RX_PROGRAM_CHANGE
; =============================================================================
; LOCATION: 0xC4DC
;
; DESCRIPTION:
; Handles incoming MIDI data when the pending MIDI event is a
; 'Program Change' event.
; This MIDI event will trigger changing the currently selected patch.
; This subroutine tests whether the synth is in 'Play/Memory Select' mode,
; and if so triggers a front-panel numeric button press event to select the
; new patch.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_program_change:                         SUBROUTINE
; If the patch number is '20', or above, set to '19'.
    CMPA    #20
    BCS     .synth_is_in_play_mode

    LDAA    #19

.synth_is_in_play_mode:
; Test whether the synth is in 'Play/Memory Select' mode. If not, exit.
    LDAB    ui_mode_memory_protect_state
    CMPB    #UI_MODE_PLAY
    BNE     .exit

    CLR     main_patch_event_flag

; Transfer A to B, then add 8.
; 8 is the front-panel button offset for 'Button 1'.
; Adding 8 will offset B from the start of the buttons.
; The input handler button processor is then called.
    TAB
    ADDB    #INPUT_BUTTON_1
    JSR     main_input_handler_process_button

.exit:
    RTS


; =============================================================================
; MIDI_RX_CONTROL_CODE
; =============================================================================
; LOCATION: 0xC4F3
;
; DESCRIPTION:
; Handles incoming MIDI data when the pending MIDI event is a 'Control Code'
; event.
; If the incoming data is the first of the two required bytes, this function
; will store the incoming MIDI data, and jump back to process any further
; incoming MIDI data.
; If both bytes making up the message have been received, the synth will jump
; to the appropriate CC function handler based upon the event's control
; change code.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_control_code:                           SUBROUTINE
; Test if the number of data bytes received already is non-zero.
; If so, all the necessary data had now been received. Proceed to processing
; the MIDI event.
; Otherwise, store the incoming byte and proceed to process the next
; incoming MIDI data messages.
    TST     midi_rx_data_count
    BNE     .midi_rx_cc_complete

    INC     midi_rx_data_count
    STAA    <midi_rx_first_data_byte
    JMP     midi_process_incoming_data

.midi_rx_cc_complete:
; Load the necessary data, and jump to the subroutine to add a new voice with
; the specified note.
    CLR     midi_rx_data_count
    LDAB    <midi_rx_first_data_byte

    JSR     jumpoff
; MIDI CC function jumpoff table.
    DC.B .exit - *
    DC.B 1
    DC.B midi_rx_cc_1_mod_wheel - *
    DC.B 2
    DC.B midi_rx_cc_2_breath_controller - *
    DC.B 3
    DC.B .exit - *
    DC.B 5
    DC.B midi_rx_cc_5_portamento_time - *
    DC.B 6
    DC.B midi_rx_cc_6_data_entry - *
    DC.B 7
    DC.B .exit - *
    DC.B $40
    DC.B midi_rx_cc_64_sustain - *
    DC.B $41
    DC.B midi_rx_cc_65_portamento - *
    DC.B $42
    DC.B .exit - *
    DC.B $60
    DC.B midi_rx_cc_96_97_data_increment_decrement - *
    DC.B $62
    DC.B .exit - *
    DC.B $7E
    DC.B midi_rx_cc_126_mode_mono - *
    DC.B $7F
    DC.B midi_rx_cc_127_poly - *
    DC.B $80
    DC.B .exit - *
    DC.B 0

.exit:
    RTS


; =============================================================================
; MIDI_RX_CC_1_MOD_WHEEL
; =============================================================================
; LOCATION: 0xC4F3
;
; DESCRIPTION:
; Handles a MIDI CC event where the event number is '1'.
; This being a mod wheel event.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_cc_1_mod_wheel:                         SUBROUTINE
    ASLA
    STAA    analog_input_mod_wheel
    RTS


; =============================================================================
; MIDI_RX_CC_2_BREATH_CONTROLLER
; =============================================================================
; LOCATION: 0xC52C
;
; DESCRIPTION:
; Handles a MIDI CC event where the event number is '2'.
; This being a breath controller event.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_cc_2_breath_controller:                 SUBROUTINE
    ASLA
    STAA    analog_input_breath_controller
    RTS


; =============================================================================
; MIDI_RX_CC_5_PORTAMENTO_TIME
; =============================================================================
; LOCATION: 0xC531
;
; DESCRIPTION:
; Handles a MIDI CC event where the event number is '5'.
; This being an update to the synth's portamento time.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_cc_5_portamento_time:                   SUBROUTINE
    JSR     portamento_convert_incoming_midi_value
    STAA    portamento_time
    JSR     portamento_calculate_rate

; If the last button pressed was button 5 in 'Function Mode', this being
; the front-panel button to update the portamento time, print the
; main menu.
; This is presumably to update the value printed on the screen, if it is
; currently visible.
    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_FUNCTION_5
    BNE     .exit

    JSR     ui_print

.exit:
    RTS


; =============================================================================
; MIDI_RX_CC_6_DATA_ENTRY
; =============================================================================
; LOCATION: 0xC545
;
; DESCRIPTION:
; Handles a MIDI Control Code event of type '6'.
; This is intended to be a 'Data Entry' event.
; The TX7 Service manual suggests that this CC event is intended to udpate the
; currently selected "voice or function parameter", however the code appears
; to only actually work in function mode, and only work when the last pressed
; button was 'Button 1' in 'Function Mode', i.e. The master tune setting.
; This strange issue is shared by the v1.8 DX7 ROM.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;
; =============================================================================
midi_rx_cc_6_data_entry:                        SUBROUTINE
    LDAB    ui_btn_numeric_last_pressed
    CMPB    #BUTTON_FUNCTION_1
    BNE     .exit

    STAA    master_tune

.exit:
    RTS


; =============================================================================
; MIDI_RX_CC_64_SUSTAIN
; =============================================================================
; LOCATION: 0xC550
;
; DESCRIPTION:
; Handles a MIDI control code message with a type of '64'.
; This is the command to affect the sustain pedal.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;         Valid data is either 0 to disable the pedal, or 0x7F to enable it.
;
; =============================================================================
midi_rx_cc_64_sustain:                          SUBROUTINE
; Test whether the incoming value is 0 (Off), or 0x7F (On).
; Any other value has no effect.
    TSTA
    BNE     .set_sustain_active

    AIMD    #~PEDAL_INPUT_SUSTAIN, pedal_status_current
    BRA     .exit

.set_sustain_active:
    CMPA    #$7F
    BNE     .exit

    OIMD    #PEDAL_INPUT_SUSTAIN, pedal_status_current

.exit:
    RTS


; =============================================================================
; MIDI_RX_CC_65_PORTAMENTO
; =============================================================================
; LOCATION: 0xC550
;
; DESCRIPTION:
; Handles a MIDI control code message with a type of '65'.
; This is the command to affect the portamento pedal.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data.
;         Valid data is either 0 to disable the pedal, or 0x7F to enable it.
;
; =============================================================================
midi_rx_cc_65_portamento:                       SUBROUTINE
; Test whether the incoming value is 0 (Off), or 0x7F (On).
; Any other value has no effect.
    TSTA
    BNE     .set_portamento_active

    AIMD    #~PEDAL_INPUT_PORTA, pedal_status_current
    BRA     .exit

.set_portamento_active:
    CMPA    #$7F
    BNE     .exit

    OIMD    #PEDAL_INPUT_PORTA, pedal_status_current

.exit:
    RTS


; =============================================================================
; MIDI_RX_CC_96_97_DATA_INCREMENT_DECREMENT
; =============================================================================
; LOCATION: 0xC570
;
; DESCRIPTION:
; Handles a MIDI control code message with a type of '96', or '97.
; These are the MIDI commands to increment, or decrement the currently
; selected parameter.
;
; ARGUMENTS:
; Registers:
; * ACCB: The MIDI control code.
;         This is either '96' for 'Yes', or '97' for 'No'.
;
; =============================================================================
midi_rx_cc_96_97_data_increment_decrement:      SUBROUTINE
    CMPA    #127
    BNE     .exit

    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_FUNCTION_1
    BEQ     .exit

; 'Function Mode' button 6 has no function, so do not perform any action.
    CMPA    #BUTTON_FUNCTION_6
    BEQ     .exit

; 'Function Mode' button 10 controls the tape remote polarity, so do not
; perform any action in this case.
    CMPA    #BUTTON_FUNCTION_10
    BEQ     .exit

; 'Function Mode' button 20 controls the synth memory protection, so do not
; perform any action in this case.
    CMPA    #BUTTON_FUNCTION_20
    BEQ     .exit

; Subtract '95' from ACCB so that the value passed to the
; increment/decrement subroutine is '1' for 'Yes', '2' for 'No'.
    SUBB    #95
    JSR     ui_increment_decrement_parameter
    JSR     ui_print_update_led_and_menu

.exit:
    RTS


; ==============================================================================
; MIDI_RX_CC_126_MODE_MONO
; ==============================================================================
; LOCATION: 0xC590
;
; DESCRIPTION:
; Handles a MIDI control code message with a type of '126'.
; This is the command to set the synth to monophonic mode.
;
; ==============================================================================
midi_rx_cc_126_mode_mono:                       SUBROUTINE
    TST     mono_poly
    BNE     midi_rx_polyphony_exit

    LDAA    #1
    STAA    mono_poly
; Falls-through below.

midi_rx_polyphony_reset_voices:
; If the synth's polyphony settings have changed, reset all of the voice data.
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count

; If the last button pressed was the 'Function Mode' button to control
; the synth's polyphony, print the synth's menu.
    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_FUNCTION_2
    BNE     midi_rx_polyphony_exit

    JSR     ui_print

midi_rx_polyphony_exit:
    RTS


; =============================================================================
; MIDI_RX_CC_127_MODE_POLY
; =============================================================================
; LOCATION: 0xC5AE
;
; DESCRIPTION:
; Handles a MIDI Control Code message with a type of '127'.
; This sets the synth to polyphonic mode.
;
; =============================================================================
midi_rx_cc_127_poly:                            SUBROUTINE
    TST     mono_poly
    BEQ     midi_rx_polyphony_exit

    CLR     mono_poly
    BRA     midi_rx_polyphony_reset_voices


; =============================================================================
; LOCATION: 0xC5B8
;
; DESCRIPTION:
; Handles incoming MIDI SysEx data.
; This subroutine is the entry-point to the SysEx state machine routines.
; Initially the number of bytes already received will be used to determine
; which state to jump to.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming MIDI SysEx data to parse.
;
; =============================================================================
midi_sysex_rx:                                  SUBROUTINE
    LDAB    <midi_rx_data_count
    JSR     jumpoff

    DC.B midi_sysex_rx_validate_manufacturer_id - *
    DC.B 1
    DC.B midi_sysex_rx_substatus - *
    DC.B 2
    DC.B midi_sysex_rx_format_param_grp - *
    DC.B 3
    DC.B midi_sysex_rx_byte_count_msb_param - *
    DC.B 4
    DC.B midi_sysex_rx_process_received_data - *
    DC.B 5
    DC.B midi_sysex_rx_bulk_data_store_jump - *
    DC.B 160
    DC.B midi_rx_sysex_bulk_data_finalise_jump - *
    DC.B 161
    DC.B .exit - *
    DC.B 0

.exit:
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received
    JMP     midi_process_incoming_data


; =============================================================================
; Thunk function used to perform a jump to a function that isn't within 255
; bytes of the main SysEx jumpoff.
; =============================================================================
midi_sysex_rx_bulk_data_store_jump:
    JMP     midi_sysex_rx_bulk_data_store


; =============================================================================
; Thunk function used to perform a jump to a function that isn't within 255
; bytes of the main SysEx jumpoff.
; =============================================================================
midi_rx_sysex_bulk_data_finalise_jump:
    JMP     midi_sysex_rx_bulk_data_finalise


; =============================================================================
; MIDI_SYSEX_RX_VALIDATE_MANUFACTURER_ID
; =============================================================================
; LOCATION: 0xC5DA
;
; DESCRIPTION:
; When receiving a SysEx message, this subroutine validates the SysEx
; manufacturer ID to determine whether it matches Yamaha's ID.
;
; ARGUMENTS:
; Registers:
; * ACCA: The received MIDI data, in this case the MIDI SysEx
;         manufacturer ID.
;
; =============================================================================
midi_sysex_rx_validate_manufacturer_id:         SUBROUTINE
; Test if the SysEx message's manufacturer code matches Yamaha's code.
; If not, abort.
    STAA    <midi_rx_first_data_byte
    CMPA    #MIDI_MANUFACTURER_ID_YAMAHA
    BNE     .manufacturer_id_invalid

; Activate, and reset the SysEx timeout counter.
    LDAA    #1
    STAA    <midi_sysex_voice_timeout_active

    CLRA
    STAA    <midi_active_sensing_rx_counter

    STAA    <midi_sysex_receive_data_active

; Increment the MIDI received data count.
    INC     midi_rx_data_count
    BRA     .exit

.manufacturer_id_invalid:
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received

.exit:
    JMP     midi_process_incoming_data


; =============================================================================
; MIDI_SYSEX_RX_SUBSTATUS_STORE
; =============================================================================
; LOCATION: 0xC5F5
;
; DESCRIPTION:
; Stores the incoming SysEx 'sub-status', and jumps to the appropriate
; handling function based upon its content.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx data.
;
; =============================================================================
midi_sysex_rx_substatus:                        SUBROUTINE
    STAA    <midi_sysex_substatus

; Jump-off based on the substatus, which occupies bit 4-7.
; If this is 0, it will be below 10, on account of the MIDI channel.
; If it is 1, it will be below 20.
; Anything else is invalid.
    TAB
    JSR     jumpoff

    DC.B midi_sysex_rx_substatus_data - *
    DC.B $10
    DC.B midi_sysex_rx_substatus_param - *
    DC.B $20
    DC.B midi_sysex_substatus_invalid - *
    DC.B 0


; =============================================================================
; MIDI_SYSEX_RX_SUBSTATUS_DATA
; =============================================================================
; LOCATION: 0xC601
;
; DESCRIPTION:
; Handles the case where the SysEx substatus indicates that the incoming
; SysEx data is a data message.
;
; ARGUMENTS:
; Registers:
; * ACCB: The incoming SysEx substatus byte.
;
; =============================================================================
midi_sysex_rx_substatus_data:                   SUBROUTINE
    LDAA    #1
    STAA    <midi_sysex_receive_data_active
; Falls-through below.

; =============================================================================
; MIDI_SYSEX_RX_SUBSTATUS_PARAM
; =============================================================================
; LOCATION: 0xC605
;
; DESCRIPTION:
; Handles the case where the SysEx substatus indicates that the incoming
; SysEx data is a parameter change message.
;
; ARGUMENTS:
; Registers:
; * ACCB: The incoming SysEx substatus byte.
;
; =============================================================================
midi_sysex_rx_substatus_param:                  SUBROUTINE
; Mask, and validate the MIDI channel.
; If this SYSEX message is not intended for this device, end the
; receipt of this SYSEX message.
    ANDB    #%1111
    CMPB    midi_rx_channel
    BNE     midi_sysex_substatus_invalid

    INC     midi_rx_data_count
    BRA     .exit

midi_sysex_substatus_invalid:
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received

.exit:
    JMP     midi_process_incoming_data


; =============================================================================
; LOCATION: 0xC618
;
; DESCRIPTION:
; Stores the incoming SysEx format/parameter group byte.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx format/parameter group byte.
;
; =============================================================================
midi_sysex_rx_format_param_grp:                 SUBROUTINE
    STAA    <midi_sysex_format_param_grp
    INC     midi_rx_data_count
    JMP     midi_process_incoming_data


; =============================================================================
; LOCATION: 0xC620
;
; DESCRIPTION:
; Stores the incoming SysEx data byte count if this is a data message, or
; parameter number if this is a parameter change message.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming byte count/parameter number byte.
;
; =============================================================================
midi_sysex_rx_byte_count_msb_param:             SUBROUTINE
    STAA    <midi_sysex_byte_count_msb_param_number
    INC     midi_rx_data_count
    JMP     midi_process_incoming_data


; =============================================================================
; LOCATION: 0xC628
;
; DESCRIPTION:
; Stores the last incoming SysEx header data, and begins processing the data.
; In the case that this is the start of a bulk data dump, this subroutine
; will set the appropriate internal registers, in the case that the incoming
; SysEx data is a parameter change this will process the message in its
; entirety.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx 'Byte Count LSB', or 'Parameter Data' byte.
;
; =============================================================================
midi_sysex_rx_process_received_data:            SUBROUTINE
    STAA    <midi_sysex_byte_count_lsb_param_data
    LDAB    <midi_sysex_substatus

; Check if the sub-status matches the code for a parameter change.
; If the status is less, it indicates we're receiving data.
; If so, branch.
    CMPB    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    BCS     midi_sysex_rx_process_data_msg

; Handle 'Parameter Change' SYSEX message.
    LDAB    <midi_sysex_format_param_grp

; Shift the 'Parameter Group' field right twice to mask it, then jump.
    LSRB
    LSRB
    JSR     jumpoff

    DC.B midi_sysex_rx_param_voice - *
    DC.B 1
    DC.B midi_sysex_rx_param_end - *
    DC.B 3
    DC.B midi_sysex_rx_param_function - *
    DC.B 4
    DC.B midi_sysex_rx_param_end - *
    DC.B 0


; =============================================================================
; MIDI_SYSEX_RX_PARAM_VOICE
; =============================================================================
; LOCATION: 0xC63F
;
; DESCRIPTION:
; Handles processing an incoming SysEX voice parameter change message.
;
; =============================================================================
midi_sysex_rx_param_voice:                      SUBROUTINE
    TST     sys_info_avail
    BEQ     midi_sysex_rx_param_end

    JSR     midi_sysex_rx_param_voice_process
    BRA     midi_sysex_rx_param_end


; =============================================================================
; LOCATION: 0xC63F
;
; DESCRIPTION:
; Handles processing an incoming SysEX function parameter change message.
;
; =============================================================================
midi_sysex_rx_param_function:                   SUBROUTINE
    LDD     <midi_sysex_byte_count_msb_param_number

; If the SysEx parameter number is less than '64', branch.
    CMPA    #64
    BCS     .function_param_below_64

; If receiving SysEx messages is not enabled, exit.
    TST     sys_info_avail
    BEQ     midi_sysex_rx_param_end

    JSR     midi_sysex_rx_param_function_64_to_78
    BRA     midi_sysex_rx_param_end

.function_param_below_64:
; If the SysEx function parameter number is below '64' it corresponds to
; a front-panel button press.
    LDAB    <midi_sysex_byte_count_lsb_param_data
    JSR     midi_sysex_rx_param_function_button
; Falls-through below.

; =============================================================================
; MIDI_SYSEX_RX_PARAM_END
; =============================================================================
; DESCRIPTION:
; Finishes receiving MIDI data from a SysEx message.
;
; =============================================================================
midi_sysex_rx_param_end:                        SUBROUTINE
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received
    RTS


; =============================================================================
; MIDI_SYSEX_RX_PROCESS_DATA_MSG
; =============================================================================
; DESCRIPTION:
; Handles an initiating an incoming SysEx message when it is a bulk data
; type message.
;
; =============================================================================
midi_sysex_rx_process_data_msg:                 SUBROUTINE
; Test whether the synth will accept SysEx data. If not, e2xit.
    TST     sys_info_avail
    BEQ     midi_sysex_rx_force_message_end

; Jumpoff based on the format of the incoming data.
    LDAB    <midi_sysex_format_param_grp
    JSR     jumpoff

    DC.B midi_sysex_rx_bulk_data_single_voice - *
    DC.B 1
    DC.B midi_sysex_rx_force_message_end - *
    DC.B 9
    DC.B midi_sysex_rx_bulk_data_32_voices - *
    DC.B $A
    DC.B midi_sysex_rx_force_message_end - *
    DC.B 0


; =============================================================================
; LOCATION: 0xC675
;
; DESCRIPTION:
; This subroutine handles initiating the receiving of a single voice bulk
; data dump. It validates the byte count, and sets the internal SysEx
; format flags.
;
; =============================================================================
midi_sysex_rx_bulk_data_single_voice:           SUBROUTINE
; Test whether the byte count MSB is equal to '1'.
; If not, this is not a valid byte count for a single voice.
    LDAA    <midi_sysex_byte_count_msb_param_number
    CMPA    #1
    BNE     midi_sysex_rx_force_message_end

; Test whether the byte count LSB is equal to '27'.
; Together with the MSB this will add up to '155'.
; The formula for the total is actually: LSB | (MSB << 7).
; If not, this is not a valid byte count for a single voice.
    LDAA    <midi_sysex_byte_count_lsb_param_data
    CMPA    #27
    BNE     midi_sysex_rx_force_message_end

    CLR     midi_sysex_format_type
    BRA     midi_sysex_rx_bulk_data_setup


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_32_VOICES
; =============================================================================
; LOCATION: 0xC686
;
; DESCRIPTION:
; This subroutine handles initiating the receiving of a 32 voice bulk
; data dump. It validates the byte count, and sets the internal SysEx
; format flags.
;
; =============================================================================
midi_sysex_rx_bulk_data_32_voices:              SUBROUTINE
; Since the bulk data dump will overwrite the internal patch memory, first
; test whether memory protection is enabled.
; If so, exit.
    TST     memory_protect
    BNE     midi_sysex_rx_force_message_end

; Test whether the byte count MSB is above '32'.
; If '32', together with the LSB this will add up to '4096'.
; The formula for the total is actually: LSB | (MSB << 7).
; If not, this is not a valid byte count for a bulk voice dump.
    LDAA    <midi_sysex_byte_count_msb_param_number
    DECA
    CMPA    #32
    BCC     midi_sysex_rx_force_message_end

    TST     midi_sysex_byte_count_lsb_param_data
    BNE     midi_sysex_rx_force_message_end

; This variable is used during storage of the incoming data.
    LDAA    #MIDI_SYSEX_FORMAT_BULK
    STAA    <midi_sysex_format_type

; Reset the incoming SysEx patch number index.
    CLR     midi_sysex_rx_bulk_patch_index
; Falls-through below.

; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_SETUP
; =============================================================================
; DESCRIPTION:
; Initialises the system in preparation of receiving a bulk data dump.
;
; =============================================================================
midi_sysex_rx_bulk_data_setup:                  SUBROUTINE
    JSR     lcd_clear_line_2
    JSR     lcd_update
    CLR     midi_sysex_rx_checksum
    INC     midi_rx_data_count
    JMP     midi_process_incoming_data


; =============================================================================
; MIDI_SYSEX_RX_FORCE_MESSAGE_END
; =============================================================================
; DESCRIPTION:
; This subroutine is used to end receiving a particular SysEx transmission.
;
; =============================================================================
midi_sysex_rx_force_message_end:                SUBROUTINE
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received
    JMP     midi_process_incoming_data


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_STORE
; =============================================================================
; LOCATION: 0xC6B4
;
; DESCRIPTION:
; Stores incoming SysEx data for a bulk voice dump.
; Based upon whether this is a single voice, or a 32 voice bulk data dump,
; this subroutine will store the data accordingly.
; In the case of a single voice, if all bytes have been received, it will set
; the SysEx state machine to a state where validation will occur.
; In the case of a 32 voice bulk data dump, after successfully receiving the
; data for an individual voice, this routine will call the subroutine for
; deserialising the received patch data.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx bulk voice data byte.
;
; =============================================================================
midi_sysex_rx_bulk_data_store:                  SUBROUTINE
; Timer interrupts are disabled, and the SysEx receive flag is set here because
; up until this point there are numerous ways in which the incoming SysEx
; message can fail validation, and the process be aborted.
    CLR     timer_ctrl_status
    LDAB    #1
    STAB    <midi_sysex_rx_active_flag

; Test whether we're storing the bulk data for a single voice, or 32.
    TST     midi_sysex_format_type
    BNE     .receiving_multiple_patches

; Load the received SysEx data count, and use this value as an index into
; the incoming SysEx bulk data temporary buffer.
; Subtract 5 to take into account the size of the SysEx header, which is
; not stored.
    LDAB    <midi_rx_data_count
    SUBB    #5
    LDX     #midi_buffer_sysex_rx_single
    ABX

; Store the incoming data.
    STAA    0,x

; Add the incoming data to the checksum byte, and store.
; Increment the received byte count, and then return to process further
; incoming data.
    ADDA    <midi_sysex_rx_checksum
    STAA    <midi_sysex_rx_checksum
    INC     midi_rx_data_count
    JMP     midi_process_incoming_data

.receiving_multiple_patches:
; Load the received SysEx data count, and use this value as an index into
; the incoming SysEx bulk data temporary buffer.
; Subtract 5 to take into account the size of the SysEx header, which is
; not stored.
    LDAB    <midi_rx_data_count
    SUBB    #5
    LDX     #midi_buffer_sysex_rx_bulk
    ABX

; Store the incoming data.
    STAA    0,x

; Add the incoming data to the checksum byte, and store.
    ADDA    <midi_sysex_rx_checksum
    STAA    <midi_sysex_rx_checksum
    LDAA    <midi_rx_data_count
    INCA
    STAA    <midi_rx_data_count

; Compare against '133' to take into account the header size.
; If a full patch has not been received, exit and process the next incoming
; MIDI data.
    CMPA    #133
    BEQ     .process_completed_patch

    JMP     midi_process_incoming_data

.process_completed_patch:
; Deserialise the newly received patch into the synth's patch memory.
; This converts it from the serialised DX7 format into the DX9 format.
    JSR     midi_sysex_rx_bulk_data_deserialise

; Increment the received patch index.
    LDAA    <midi_sysex_rx_bulk_patch_index
    INCA
    STAA    <midi_sysex_rx_bulk_patch_index

; The MSB of the SysEx bulk data byte count will contain the number of
; patches contained in the bulk data dump.
; This value is used to check whether all of the patches have been received.
    CMPA    <midi_sysex_byte_count_msb_param_number
    BEQ     .finish_receiving_bulk_data

; If the bulk voice transfer isn't finished, reset the received SysEx byte
; count to '5', which is the size of the SysEx header.
; This sets the state machine to anticipate the next incoming patch.
    LDAB    #5
    STAB    <midi_rx_data_count
    JMP     midi_process_incoming_data

.finish_receiving_bulk_data:
; Set the received data count to '160' to trigger the validation of the
; received data using the SysEx checksum.
    LDAB    #160
    STAB    <midi_rx_data_count
    JMP     midi_process_incoming_data


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_FINALISE
; =============================================================================
; LOCATION: 0xC708
;
; DESCRIPTION:
; Finalises the received SysEx bulk patch data.
; This subroutine validates the bulk data checksum, and initiates the
; deserialisation of the bulk patch data into the synth's memory.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx checksum byte.
;
; =============================================================================
midi_sysex_rx_bulk_data_finalise:               SUBROUTINE
    CLR     midi_sysex_rx_active_flag

; Add the incoming final checksum byte to the checksum, and test whether it
; is equal to zero. If not, a MIDI transmission error has occurred.
    ADDA    <midi_sysex_rx_checksum
    ANDA    #%1111111
    BNE     .checksum_error

    TST     midi_sysex_format_type
    BNE     .finalise_all_patches

; Copy the received patch to the 'incoming' buffer, and load it.
    JSR     midi_sysex_rx_bulk_data_serialise_single_to_bulk
    LDAA    #20
    STAA    <midi_sysex_rx_bulk_patch_index
    JSR     midi_sysex_rx_bulk_data_deserialise

; The carry flag being set here indicates that there was an error during
; the deserialisation/conversion process.
    BCS     .exit

    LDAB    #20
    JSR     patch_set_new_index_and_copy_edit_to_compare
    JSR     patch_load_clear_compare_mode_state

; Reset operator 'On/Off' status.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status

    JSR     led_print_patch_number
    JSR     lcd_clear
    LDX     #str_midi_received
    JSR     lcd_strcpy

; Print the incoming patch name.
; This copies each character of the patch name to the LCD 'next' buffer.
    LDX     #(lcd_buffer_next + 20)
    STX     <memcpy_ptr_dest
    LDX     #midi_buffer_sysex_rx_bulk + $76

.print_patch_name_loop:
    LDAB    0,x
    JSR     lcd_store_character_and_increment_ptr
    INX
    CPX     #patch_buffer
    BNE     .print_patch_name_loop

    JSR     lcd_update
    BRA     .exit

.finalise_all_patches:
; Since each patch is 128 bytes in size, and the SysEx data has a 7 bit length,
; the data length's MSB indicates the number of patches in the dump.
; Decrement the MSB count to convert the total number of patches in the
; bulk patch dump to a usable patch index.
; If this is more than the highest patch buffer index, clamp.
    LDAB    <midi_sysex_byte_count_msb_param_number
    DECB
    CMPB    #19
    BLS     .set_index

    LDAB    #19

.set_index:
; Set the new patch index.
    JSR     patch_set_new_index_and_copy_edit_to_compare
    JSR     patch_load_clear_compare_mode_state

; Reset operator 'On/Off' status.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status

    JSR     ui_print_update_led_and_menu
    JSR     lcd_clear_line_2
    LDX     #str_midi_received
    JSR     lcd_strcpy
    JSR     lcd_update
    BRA     .exit

.checksum_error:
    JSR     lcd_clear_line_2
    LDX     #str_midi_csum_error
    JSR     lcd_strcpy
    JSR     lcd_update

.exit:
    JSR     midi_reenable_timer_interrupt
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received
    RTS

str_midi_received:                      DC " MIDI RECEIVED",0
str_midi_csum_error:                    DC "MIDI CSUM ERROR", 0


; =============================================================================
; HANDLER_OCF
; =============================================================================
; LOCATION: 0xC7B3
;
; DESCRIPTION:
; Handles the OCF (Output Compare Counter) timer interrupt (IRQ2).
; This is where all of the synth's periodicly repeated functions are called.
;
; =============================================================================
handler_ocf:                                    SUBROUTINE
    CLR     timer_ctrl_status
    CLI

; Reset the free running counter.
    LDX     #0
    STX     <free_running_counter
    COM     portamento_update_toggle

    JSR     active_sensing_update_tx_counter
    JSR     handler_ocf_sysex_voice_timeout
    JSR     pitch_bend_process

    JSR     lfo_process
    JSR     mod_amp_update

; This flag is 'toggled' On/Off with each interrupt.
; This flag is used to determine whether portamento, or pitch modulation
; should be updated in this interrupt. The reason is likely to save CPU
; cycles used by these expensive operations.
    TST     portamento_update_toggle
    BPL     .update_portamento

    JSR     voice_update_sustain_status
    JSR     mod_pitch_update
    JSR     handler_ocf_compare_mode_led_blink
    BRA     .reset_timers

.update_portamento:
    JSR     portamento_process

.reset_timers:
; Clear the OCF interrupt flag by reading from the timer control register.
    LDAA    <timer_ctrl_status
    LDX     #2500
    STX     <output_compare
    LDAA    #TIMER_CTRL_EOCI
    STAA    <timer_ctrl_status

    RTI


; =============================================================================
; HANDLER_SCI
; =============================================================================
; LOCATION: 0xC7ED
;
; DESCRIPTION:
; Top-level handler for all hardware Serial Communication Interface events.
; This subroutine handles the buffering of all incoming, and outgoing MIDI
; messages.
;
; =============================================================================
handler_sci:                                    SUBROUTINE
    LDAA    <sci_ctrl_status

; If Status[RDRF] is set, it means there is data in the receive
; register. If so, branch.
    ASLA
    BCS     .receive_incoming_data

    ASLA

; Branch if Status[ORFE] is set.
    BCS     .midi_overrun_framing_error

; Checks if Status[TDRE] is clear.
; If so the serial interface is ready to transmit new data.
    BMI     .is_tx_buffer_empty

    BRA     .handler_sci_exit

.receive_incoming_data:
; Store received data into the RX buffer, and increment the write pointer.
    LDAA    <sci_rx
    LDX     <midi_buffer_ptr_rx_write
    STAA    0,x
    INX
    CPX     #midi_buffer_rx_end
    BNE     .is_rx_buffer_full

; Reset the RX data ring buffer if it has reached the end.
    LDX     #midi_buffer_rx

.is_rx_buffer_full:
; If the RX write pointer wraps around to the read pointer this indicates
; a MIDI buffer overflow.
    CPX     <midi_buffer_ptr_rx_read
    BEQ     .midi_buffer_full

    STX     <midi_buffer_ptr_rx_write
    BRA     .handler_sci_exit

.midi_buffer_full:
    LDAA    #MIDI_ERROR_BUFFER_FULL
    STAA    <midi_error_code
    JSR     midi_reset
    BRA     .handler_sci_exit

.is_tx_buffer_empty:
    LDX     <midi_buffer_ptr_tx_read
    CPX     <midi_buffer_ptr_tx_write

; If the read, and write pointer are equal, it indicates the buffer is empty.
    BEQ     .tx_buffer_empty

; Load the next MIDI byte to be sent.
; Test whether this is a MIDI status byte.
    LDAA    0,x
    BPL     .tx_byte

; If the next byte to be sent is a status command, it is stored in a
; variable so that the synth can take advantage of the MIDI protocol
; 'Running Status' feature.
; http://midi.teragonaudio.com/tech/midispec/run.htm
; This feature allows the synth to omit the status byte when sending
; multiple MIDI messages of the same type in a row.
; If the status byte is a MIDI SysEx start command, this check is ignored.
    CMPA    #MIDI_STATUS_SYSEX_START
    BEQ     .store_last_sent_command

    CMPA    <midi_last_sent_command
    BEQ     .increment_tx_ptr

.store_last_sent_command:
    STAA    <midi_last_sent_command

.tx_byte:
    STAA    <sci_tx

.increment_tx_ptr:
    INX

; Check whether the read pointer has reached the end of the MIDI TX buffer,
; if so, the read pointer is reset to the start.
    CPX     #midi_buffer_rx
    BNE     .store_tx_ptr_read
    LDX     #midi_buffer_tx

.store_tx_ptr_read:
    STX     <midi_buffer_ptr_tx_read
    BRA     .handler_sci_exit

.tx_buffer_empty:
    LDAA    #(SCI_CTRL_TE | SCI_CTRL_RE | SCI_CTRL_RIE | SCI_CTRL_TDRE)
    STAA    <sci_ctrl_status
    BRA     .handler_sci_exit

.midi_overrun_framing_error:
    LDAA    #MIDI_ERROR_OVERRUN
    STAA    <midi_error_code
    JSR     midi_reset
    LDAA    <sci_rx

.handler_sci_exit:
    RTI


; At this point the DX9 ROM contains an unknown fragment of 6303 code.
; It contains references to memory addresses that are not in the DX9's
; address space.
; This is most likely a remnant of whatever development system Yamaha used to
; develop the DX9
    INCLUDE "binary_fragment.asm"


; =============================================================================
; LOCATION: 0xD000
;
; DESCRIPTION:
; Creates an artificial 'delay' in the system by pushing, and pulling from the
; stack.
; This whole sequence takes 14 CPU cycles in total. Four each for the pushes,
; three for the pulls.
;
; =============================================================================
delay:                                          SUBROUTINE
    PSHA
    PULA
    PSHA
    PULA
    RTS


; =============================================================================
; LOCATION: 0xD005
;
; DESCRIPTION:
; Scales a particular patch value from its serialised range of 0-99, to its
; scaled 16-bit representation. Returning the result in ACCD.
; e.g.
;   Scale(50) = 33000
;   Scale(99) = 65340
;
; This is performed by multiplying the source value by 665. Since the HD6303
; can only perform 8-bit arithmetic, this is done by multiplying the value
; by 165 (665/4), and then doubling it twice by bit-shifts.
;
; ARGUMENTS:
; Registers:
; * ACCA: The byte to scale to 16-bit form.
;
; RETURNS:
; * ACCD: The scaled value.
;
; =============================================================================
patch_convert_serialised_value_to_internal:     SUBROUTINE
    LDAB    #165
    MUL
    LSLD
    LSLD

    RTS


; =============================================================================
; PORTAMENTO_CONVERT_INCOMING_MIDI_VALUE
; =============================================================================
; LOCATION: 0xD00B
;
; DESCRIPTION:
; Converts an incoming portamento time value received via a MIDI control code
; message to the synth's internal format.
;
; ARGUMENTS:
; Registers:
; * ACCA: The value to scale.
;
; RETURNS:
; * ACCD: The scaled value.
;
; =============================================================================
portamento_convert_incoming_midi_value:         SUBROUTINE
    LDAB    #200
    MUL
    RTS


; =============================================================================
; VOICE_RESET_FREQUENCY_DATA
; =============================================================================
; LOCATION: 0xD00F
;
; DESCRIPTION:
; Resets the synth's internal voice frequency data.
; This resets the status of each of the synth's 16 voices, and their associated
; frequency data.
; This includes the 'Note Frequency', and voice status, the 'Current', and
; 'Target' frequencies for each voice.
;
; =============================================================================
voice_reset_frequency_data:                     SUBROUTINE
    PSHA
    PSHB
    PSHX

; Reset the voice note frequency and status array.
; This is accomplished by writing 0x0000 in each entry, which sets a null
; note frequency, and a 'Voice Off' status.
    CLRA
    CLRB
    LDX     #voice_status

.reset_status_loop:
    STD     0,x
    INX
    INX
    CPX     #(voice_status + 32)
    BNE     .reset_status_loop

; Reset the two voice pitch buffers.
; Writes a default value into the 'Voice Current Pitch',
; and 'Voice Target Pitch' arrays.
; @TODO: Does this value represent the 11th octave?
    LDD     #$2EA8

.reset_frequency_buffers_loop:
    STD     0,x
    INX
    INX
    CPX     #(voice_frequency_current + 32)
    BNE     .reset_frequency_buffers_loop

    PULX
    PULB
    PULA
    RTS


; =============================================================================
; VOICE_RESET_EGS
; =============================================================================
; LOCATION: 0xD030
;
; DESCRIPTION:
; Resets all voices on the EGS chip.
; This involves resetting all of the operators to their default, maximum level,
; and then sending an 'off' voice event for all of the synth's 16 voices,
; followed by an 'on' event, and another 'off' event.
; It's quite likely that sending this sequence of events to the EGS resets the
; current envelope stage for all of the synth's notes.
;
; =============================================================================
voice_reset_egs:                                SUBROUTINE
    PSHA
    PSHB
    PSHX

    BSR     voice_reset_egs_operator_level

    LDAA    #EGS_VOICE_EVENT_OFF
    BSR     voice_reset_egs_send_event_for_all_voices
    LDAA    #EGS_VOICE_EVENT_ON
    BSR     voice_reset_egs_send_event_for_all_voices
    LDAA    #EGS_VOICE_EVENT_OFF
    BSR     voice_reset_egs_send_event_for_all_voices

    PULX
    PULB
    PULA

    RTS


; =============================================================================
; VOICE_RESET_EGS_OPERATOR_LEVEL
; =============================================================================
; LOCATION: 0xD045
;
; DESCRIPTION:
; Resets the level of each of the synth's four operators to their default
; maximum value.
; It does this by writing to the EGS chip's operator level array.
;
; =============================================================================
voice_reset_egs_operator_level:                 SUBROUTINE
    LDAB    #96
    LDAA    #$FF
    LDX     #egs_operator_level

.reset_operator_level_loop:
; Reset every value in the EGS operator level array.
; 16 voices * 6 operators = 96.
    STAA    0,x
    JSR     delay
    INX
    DECB
    BNE     .reset_operator_level_loop

    RTS


; =============================================================================
; VOICE_RESET_EGS_SEND_EVENT_FOR_ALL_VOICES
; =============================================================================
; LOCATION: 0xD056
;
; DESCRIPTION:
; Sends a particular 'event' byte to the EGS for all 16 voices.
; This is used in resetting the synth's voices.
;
; ARGUMENTS:
; Registers:
; * ACCA: The 'event' data to the EGS chip for all voices.
;
; =============================================================================
voice_reset_egs_send_event_for_all_voices:      SUBROUTINE
    LDAB    #16

.send_event_for_all_voices_loop:
    STAA    egs_key_event
    JSR     delay

; Since the voice number is stored in fields 2-5, incrementing the index
; by 4 will increment the voice number field by one.
    ADDA    #4
    DECB
    BNE     .send_event_for_all_voices_loop

    RTS


; =============================================================================
; PATCH_ACTIVATE
; =============================================================================
; LOCATION: 0xD064
;
; DESCRIPTION:
; This subroutine is responsible for 'activating' the patch that is currently
; loaded into the synth's edit buffer.
; This subroutine loads the relevant patch data to the EGS, and OPS voice
; chips, which are responsible for performing the actual voice synthesis.
;
; Most of the functionality in this function is performed on a 'per-operator'
; basis, with a callback function being loaded, and called once for each of
; the four operators.
;
; =============================================================================
patch_activate:                                 SUBROUTINE
    PSHA
    PSHB
    PSHX

; Load the operator EG rates.
    LDX     #patch_activate_operator_eg_rate
    JSR     patch_activate_call_function_per_operator

; Load the operator EG levels.
    LDX     #patch_activate_operator_eg_level
    JSR     patch_activate_call_function_per_operator

; Load the operator keyboard scaling level.
    LDX     #patch_activate_operator_keyboard_scaling_level
    JSR     patch_activate_call_function_per_operator

; Load operator detune.
    LDX     #patch_activate_operator_detune
    JSR     patch_activate_call_function_per_operator

; Load operator frequency.
    LDX     #patch_activate_operator_frequency
    JSR     patch_activate_call_function_per_operator

; Load operator keyboard scaling rate.
    LDX     #patch_activate_operator_keyboard_scaling_rate
    JSR     patch_activate_call_function_per_operator

; Load algorithm, and feedback levels to the OPS chip.
    JSR     patch_activate_mode_algorithm_feedback
    JSR     patch_activate_lfo
    JSR     portamento_calculate_rate
    JSR     voice_set_key_transpose_base_frequency
    PULX
    PULB
    PULA

    RTS


; =============================================================================
; PATCH_ACTIVATE_CALL_FUNCTION_PER_OPERATOR
; =============================================================================
; LOCATION: 0xD09B
;
; DESCRIPTION:
; This subroutine is used to call a particular function once per each of the
; synth's four operators. It is used during the 'patch activation' routine.
;
; ARGUMENTS:
; Registers:
; * IX:   The callback function that will be called once for each of the
;         synth's four operators.
;
; MEMORY USED:
; * 0x86:   The current operator number the callback function is being
;           called for.
; * 0x87:   The 'offset' for the operator currently being processed.
;           Since the operator data in the patch buffer consists of four
;           sequential arrays of 15 bytes, this offset is incremented
;           by 15 with each iteration of the operator loop, and used as
;           an offset into the operator data array in the edit buffer.
;
; =============================================================================
patch_activate_call_function_per_operator:      SUBROUTINE
; The operator number, and offset are adjacent variables.
; This operation saves both onto the stack.
; @TODO: Why is this performed?
    LDD     <patch_activate_operator_number
    PSHA
    PSHB

    CLRA
    CLRB
    STD     <patch_activate_operator_number

.call_function_per_operator_loop:
    PSHX
    JSR     0,x
    PULX
    INC     patch_activate_operator_number

; Add '15' to the offset to increment the offset to the next operator.
; Once this has reached 60, all four operators have been processed.
    LDAB    #15
    ADDB    <patch_activate_operator_offset
    STAB    <patch_activate_operator_offset
    CMPB    #60
    BNE     .call_function_per_operator_loop

    PULB
    PULA
    STD     <patch_activate_operator_number

    RTS


; =============================================================================
; PATCH_ACTIVATE_LOAD_MODE_ALGORITHM_FEEDBACK_TO_OPS
; =============================================================================
; LOCATION: 0xD0B9
;
; DESCRIPTION:
; Called as part of the 'Patch Activation' routine.
; This subroutine loads the 'Mode', 'Algorithm', and 'Feedback' values from
; the current patch to the OPS chip.
;
; =============================================================================
patch_activate_mode_algorithm_feedback:         SUBROUTINE
; Load the currently loaded patch's algorithm, and use this as an index
; into the algorithm conversion table.
; From this the correct DX7 algorithm number corresponding to the current
; algorithm can be loaded.
    LDX     #table_algorithm_conversion
    LDAB    patch_edit_algorithm
    ABX
    LDAB    0,x

; Shift this value left 3 times, and combine with the feedback value to
; create the combined value to load to the OPS.
    ASLB
    ASLB
    ASLB
    ORAB    patch_edit_feedback

; Test whether oscillator sync is enabled.
; If so, add '32' to this value to create the correct bitmask to load to
; the OPS register.
    LDAA    #%110000
    TST     patch_edit_oscillator_sync
    BNE     .load_mode_alg_to_ops

    ADDA    #%100000

.load_mode_alg_to_ops:
; Load ACCA+ACCB to these two adjacent OPS registers.
    STD     <ops_mode

    RTS

; =============================================================================
; Algorithm Conversion Table
; This table is used to convert algorithms between the DX9 format, and the
; original DX7 format used in SysEx transmission, and in patch activation.
; Each index contains the DX7/OPS algorithm corresponding to the index
; number's algorithm on the DX9.
; =============================================================================
table_algorithm_conversion:
    DC.B 0
    DC.B 13
    DC.B 7
    DC.B 6
    DC.B 4
    DC.B 21
    DC.B 30
    DC.B 31


; =============================================================================
; PATCH_ACTIVATE_PARSE_LFO
; =============================================================================
; LOCATION: 0xD0DC
;
; DESCRIPTION:
; This routine is responsible for parsing the serialised patch LFO data, and
; setting up the internal representation of the data used in internal LFO
; processing.
;
; =============================================================================
patch_activate_lfo:                             SUBROUTINE
    LDX     #patch_edit_lfo_speed

    JSR     patch_activate_get_lfo_phase_increment
    STD     <lfo_phase_increment

; Parse LFO delay.
    JSR     patch_activate_get_lfo_delay_increment
    STD     <lfo_delay_increment

; Parse the LFO Pitch Mod Depth.
    LDAA    2,x
    JSR     patch_convert_serialised_value_to_internal
    STAA    <lfo_mod_depth_pitch

; Parse the LFO Amp Mod Depth.
    LDAA    3,x
    JSR     patch_convert_serialised_value_to_internal
    STAA    <lfo_mod_depth_amp

; Parse the LFO waveform.
    LDAA    4,x
    STAA    lfo_waveform

; Parse the LFO Pitch Mod Sensitivity.
    LDAB    5,x
    LDX     #table_pitch_mod_sensitivity
    ABX
    LDAA    0,x
    STAA    lfo_pitch_mod_sensitivity

    RTS


; =============================================================================
; Pitch Mod Sensitivity Table
; This table is used to translate serialised LFO Pitch Mod Sensitivity values
; into their internal representation.
; =============================================================================
table_pitch_mod_sensitivity:
    DC.B 0
    DC.B 10
    DC.B 20
    DC.B 33
    DC.B 55
    DC.B 92
    DC.B 153
    DC.B 255


; =============================================================================
; PATCH_ACTIVATE_GET_LFO_PHASE_INCREMENT
; =============================================================================
; LOCATION: 0xD110
;
; DESCRIPTION:
; Parses the patch LFO speed value, and calculates the correct phase
; increment for the LFO. This subroutine is called during the patch
; activation process.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the LFO speed, in patch memory.
;
; RETURNS:
; * ACCD: The LFO phase increment.
;
; =============================================================================
patch_activate_get_lfo_phase_increment:         SUBROUTINE
; If the LFO speed is set to zero, clamp it to a minimum of '267'. This is
; done so that the LFO software arithmetic works.
    LDAA    0,x
    BNE     .speed_above_zero

    INCA
    BRA     .clamp_at_minimum

.speed_above_zero:
    JSR     patch_convert_serialised_value_to_internal
    CMPA    #160
    BCS     .clamp_at_minimum

    TAB
    SUBB    #160
    LSRB
    LSRB
    ADDB    #11
    BRA     .exit

.clamp_at_minimum:
    LDAB    #11

.exit:
    MUL
    RTS


; =============================================================================
; LOCATION: 0xD12B
;
; DESCRIPTION:
; Processes the patch's LFO delay value to compute the LFO delay increment.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the synth's LFO speed value in patch memory.
;
; RETURNS:
; * ACCD: The parsed LFO delay value.
;
; =============================================================================
patch_activate_get_lfo_delay_increment:         SUBROUTINE
; =============================================================================
; LOCAL TEMPORARY VARIABLES
; =============================================================================
; Since the patch is never activated at the same time as the front-panel input
; is being updated, this address can be reused for the LFO rate increment
; calculation.
.lfo_scratch:                                   EQU $88

; =============================================================================
; Subtract the serialised LFO delay value from 99.
    LDAA    #99
    SUBA    1,x

    TAB
    ANDB    #%1110000
    LSRB
    LSRB
    LSRB
    LSRB
    SUBB    #7
    NEGB
    STAB    <.lfo_scratch

    ANDA    #%1111
    ORAA    #%10000
    ASLA
    CLRB

.rotate_loop:
    LSRD
    DEC     .lfo_scratch
    BNE     .rotate_loop

    RTS


; =============================================================================
; LOCATION: 0xD148
;
; DESCRIPTION:
; Parses the frequency scaling values for the currently selected operator, and
; loads it to the appropriate register inside the EGS chip.
;
; =============================================================================
patch_activate_operator_frequency:              SUBROUTINE
    LDX     #patch_buffer_edit
    LDAB    <patch_activate_operator_offset
    ABX
    PSHX

; Use the serialised 'Op Freq Coarse' value (0-31) as an index into the
; coarse frequency lookup table.
; Store the resulting coarse freq value on the stack.
    LDAB    PATCH_OP_FREQ_COARSE,x
    ASLB
    LDX     #table_operator_frequency_coarse
    ABX
    LDD     0,x
    PULX
    PSHA
    PSHB

; Load the operator's fine frequency, and multiply this value by '2'.
; This value will be used as an index into the fine frequency lookup table.
; The resulting value will be added to the coarse frequency to produce
; the final operating frequency scaling.
    LDAB    PATCH_OP_FREQ_FINE,x
    CLRA
    LSLD
    ADDD    #table_operator_frequency_fine
    XGDX
    PULB
    PULA

; Add the coarse, and fine frequency values together.
    ADDD    0,x
    ADDD    #$232C

; Truncate to 14-bits.
    ANDB    #%11111110
    PSHB

; Write to the EGS operator frequency buffer.
    LDX     #egs_operator_frequency
    LDAB    <patch_activate_operator_number
    ASLB
    ABX
    PULB
    STAA    0,x
    NOP
    STAB    1,x

    RTS


; =============================================================================
; Coarse Operator Frequency Lookup Table.
; =============================================================================
table_operator_frequency_coarse:
    DC.W $F000
    DC.W 0
    DC.W $1000
    DC.W $195C
    DC.W $2000
    DC.W $2528
    DC.W $295C
    DC.W $2CEC
    DC.W $3000
    DC.W $32B8
    DC.W $3528
    DC.W $375A
    DC.W $395C
    DC.W $3B34
    DC.W $3CEC
    DC.W $3E84
    DC.W $4000
    DC.W $4168
    DC.W $42B8
    DC.W $43F8
    DC.W $4528
    DC.W $4648
    DC.W $475A
    DC.W $4860
    DC.W $495C
    DC.W $4A4C
    DC.W $4B34
    DC.W $4C14
    DC.W $4CEC
    DC.W $4DBA
    DC.W $4E84
    DC.W $4F44

; =============================================================================
; Fine Operator Frequency Lookup Table.
; =============================================================================
table_operator_frequency_fine:
    DC.W 0
    DC.W $3A
    DC.W $75
    DC.W $AE
    DC.W $E7
    DC.W $120
    DC.W $158
    DC.W $18F
    DC.W $1C6
    DC.W $1FD
    DC.W $233
    DC.W $268
    DC.W $29D
    DC.W $2D2
    DC.W $306
    DC.W $339
    DC.W $36D
    DC.W $39F
    DC.W $3D2
    DC.W $403
    DC.W $435
    DC.W $466
    DC.W $497
    DC.W $4C7
    DC.W $4F7
    DC.W $526
    DC.W $555
    DC.W $584
    DC.W $5B2
    DC.W $5E0
    DC.W $60E
    DC.W $63B
    DC.W $668
    DC.W $695
    DC.W $6C1
    DC.W $6ED
    DC.W $719
    DC.W $744
    DC.W $76F
    DC.W $799
    DC.W $7C4
    DC.W $7EE
    DC.W $818
    DC.W $841
    DC.W $86A
    DC.W $893
    DC.W $8BC
    DC.W $8E4
    DC.W $90C
    DC.W $934
    DC.W $95C
    DC.W $983
    DC.W $9AA
    DC.W $9D1
    DC.W $9F7
    DC.W $A1D
    DC.W $A43
    DC.W $A69
    DC.W $A8F
    DC.W $AB4
    DC.W $AD9
    DC.W $AFE
    DC.W $B22
    DC.W $B47
    DC.W $B6B
    DC.W $B8F
    DC.W $BB2
    DC.W $BD6
    DC.W $BF9
    DC.W $C1C
    DC.W $C3F
    DC.W $C62
    DC.W $C84
    DC.W $CA7
    DC.W $CC9
    DC.W $CEA
    DC.W $D0C
    DC.W $D2E
    DC.W $D4F
    DC.W $D70
    DC.W $D91
    DC.W $DB2
    DC.W $DD2
    DC.W $DF3
    DC.W $E13
    DC.W $E33
    DC.W $E53
    DC.W $E72
    DC.W $E92
    DC.W $EB1
    DC.W $ED0
    DC.W $EEF
    DC.W $F0E
    DC.W $F2D
    DC.W $F4C
    DC.W $F6A
    DC.W $F88
    DC.W $FA6
    DC.W $FC4
    DC.W $FE2
    DC.W $1000


; =============================================================================
; PATCH_ACTIVATE_OPERATOR_DETUNE
; =============================================================================
; OPERATOR: 0xD285
;
; DESCRIPTION:
; Loads operator detune values to the EGS operator detune buffer.
; Note: This subroutine differs from how the DX7's implementation in how it
; calculates the final value. The DX7 version looks up the value in a table,
; while this subroutine gets a one's complement version of the value in the
; case it is negative.
; According to the 'DX7 Technical Analysis' book, bit 3 of the EGS detune
; buffer is the 'sign' bit, and the higher bits are ignored.
;
; =============================================================================
patch_activate_operator_detune:                 SUBROUTINE
; Load the current operator's detune value.
    LDX     #patch_buffer_edit
    LDAB    <patch_activate_operator_offset
    ABX
    LDAA    PATCH_OP_DETUNE,x

; If the operator detune value is below 7, get it's one's complement.
; Otherwise subtract 7, to create a value essentially between -7 - 7.
    CMPA    #7
    BCC     .detune_value_positive

; If the operator detune setting is negative, invert the value.
; Only the first 4 bits will be acknowledged by the EGS, with bit 3 used to
; indicate the sign of the value. Bit 3 being set meaning a negative value.
; @TODO: Figure out why this differs from the DX7 implementation.
    COMA
    BRA     .load_detune_value_to_egs

.detune_value_positive:
; If the detune value is positive, subtract 7 to start at 0.
    SUBA    #7

.load_detune_value_to_egs:
    LDX     #egs_operator_detune
    LDAB    <patch_activate_operator_number
    ABX
    STAA    0,x

    RTS


; =============================================================================
; PATCH_ACTIVATE_LOAD_EGS_OPERATOR_EG_RATE
; =============================================================================
; LOCATION: 0xD29F
;
; DESCRIPTION:
; Loads and parses the current operator's EG rate values, then loads these
; values to the appropriate registers in the EGS.
;
; =============================================================================
patch_activate_operator_eg_rate:                SUBROUTINE
    LDX     #patch_buffer_edit
    LDAB    <patch_activate_operator_offset
    ABX
    STX     <copy_ptr_src

; Set the destination pointer to the EGS EG rate register.
    LDX     #egs_operator_eg_rate

; Shift the operator number left twice to increment by 4.
    LDAB    <patch_activate_operator_number
    ASLB
    ASLB
    ABX
    STX     <copy_ptr_dest

; Store the loop counter.
    LDAB    #4
    STAB    <copy_counter

.activate_eg_rate_loop:
    LDX     <copy_ptr_src
    LDAA    0,x

; The EG rate value (stored in range 0 - 99) is multiplied by 164, and then
; only the MSB is kept. This effectively shifts it >> 8. Effectively scaling
; it to a value between 0-64.
    LDAB    #164
    MUL

; Increment the source, and destination pointers.
    INX
    STX     <copy_ptr_src
    LDX     <copy_ptr_dest
    STAA    0,x
    INX
    STX     <copy_ptr_dest

; Decrement the loop counter.
    DEC     copy_counter
    BNE     .activate_eg_rate_loop

    RTS


; =============================================================================
; PATCH_ACTIVATE_OPERATOR_EG_LEVEL
; =============================================================================
; DESCRIPTION:
; This function parses the patch's operator EG values, converting the
; serialised values stored in the patch to the internal representation. It then
; loads the parsed values to the EGS chip.
;
; Note that this differs from how the DX7 calculates operator EG level.
; The DX7 uses the serialised patch EG levels as an index into the logarithmic
; curve table, then scales the result to a value between 0-63, with a lower
; level indicating a louder operator volume.
; The DX9 uses a simple algorithm to scale the serialised EG level (0-99) to a
; linear level between 63-0.
; ~(((operator_eg_level × 165) >> 8) + 0xC0)
;
; =============================================================================
patch_activate_operator_eg_level:               SUBROUTINE
; Save a pointer to the current operator's EG levels.
    LDX     #patch_buffer_edit + PATCH_OP_EG_LEVEL_1
    LDAB    <patch_activate_operator_offset
    ABX
    STX     <copy_ptr_src

; Shift twice to multiply the operator number by 4, to correctly index the
; operator EG level register on the EGS.
    LDX     #egs_operator_eg_level
    LDAB    <patch_activate_operator_number
    ASLB
    ASLB
    ABX
    STX     <copy_ptr_dest

    LDAB    #4
    STAB    <copy_counter

.parse_eg_level_loop:
    LDX     <copy_ptr_src
    LDAA    0,x

; Multiply by 165 to convert the serialised 0-99 level to a value between
; 0-64, stored in ACCA.
    LDAB    #165
    MUL

; The operator level is stored on the EGS as a 6-bit value, with lower values
; increasing in volume.
; Addding 0xC0/192/0b11000000 sets the two highest bits. When this value is '
; inverted, the top two bits are cleared, creating the final 6-bit value.
    ADDA    #$C0
    COMA

    INX
    STX     <copy_ptr_src

; Write the parsed EG level value to the EGS register.
    LDX     <copy_ptr_dest
    STAA    0,x
    INX
    STX     <copy_ptr_dest

    DEC     copy_counter
    BNE     .parse_eg_level_loop

    RTS


; =============================================================================
; PATCH_ACTIVATE_OPERATOR_KEYBOARD_SCALING_RATE
; =============================================================================
; DESCRIPTION:
; Loads the 'Keyboard Rate Scaling' value for the current operator, and combines
; it with the 'Amp Mod Sensitivity' value to create the 'combined' value
; expected by the EGS' internal registers.
;
; ARGUMENTS:
; Memory:
; * patch_activate_operator_number: The operator number being activated.
; * patch_activate_operator_offset: The offset of the current operator in
;    patch memory.
;
; =============================================================================
patch_activate_operator_keyboard_scaling_rate:  SUBROUTINE
    LDX     #patch_edit_operator_4_keyboard_scaling_rate
    LDAB    <patch_activate_operator_offset
    ABX

; Load AMP_MOD_SENS into ACCA.
    LDAA    1,x
    ASLA
    ASLA
    ASLA

; Load KBD_RATE_SCALING into ACCB.
    LDAB    0,x
    ANDB    #%111

; Combine the values into the format expected by the EGS.
    ABA

; Write the combined value to the appropriate EGS register.
    LDX     #egs_operator_keyboard_scaling
    LDAB    <patch_activate_operator_number
    ABX
    STAA    0,x

    RTS


; =============================================================================
; PATCH_ACTIVATE_OPERATOR_KEYBOAD_SCALING_LEVEL
; =============================================================================
; LOCATION: 0xD315
;
; DESCRIPTION:
; Parses the serialised keyboard scaling level values, and constructs the
; operator keyboard scaling level curve for the selected operator.
;
; =============================================================================
patch_activate_operator_keyboard_scaling_level: SUBROUTINE
    LDX     #patch_buffer_edit + PATCH_OP_KBD_SCALE_LVL
    LDAB    <patch_activate_operator_offset
    ABX
    LDAA    0,x
    JSR     patch_convert_serialised_value_to_internal
    STAA    <operator_keyboard_scaling_rate_scaled

; Load the operator level.
    LDAB    3,x
    CMPB    #20
; If less than 20, branch.
    BCS     .operator_level_below_20

    LDAA    #99
    SUBA    3,x
    BRA     .store_scaled_level_value

.operator_level_below_20:
    LDX     #table_operator_keyboard_scaling_level_below_20
    ABX
    LDAA    0,x

.store_scaled_level_value:
    ASLA
    STAA    <operator_keyboard_scaling_level_scaled

; Calculate the index into the level curve table based on the operator number.
    LDX     #operator_keyboard_scaling_level_curve_table
    LDAB    <patch_activate_operator_number
    LDAA    #29
    MUL
    ABX
    STX     <copy_ptr_dest

; The following loop creates the 29 byte operator keyboard scaling level curve
; data. Unlike the DX7, the curve is linear, and is created by multiplying an
; entry from an exponential curve table together with the keyboard scaling rate
; and level values.
    CLRB
.create_scaling_curve_loop:
    PSHB
    LDX     #table_operator_keyboard_scaling_level
    ABX
    LDAA    0,x
    LDAB    <operator_keyboard_scaling_rate_scaled
    MUL
    ADDA    <operator_keyboard_scaling_level_scaled
    BCC     .store_scaling_curve_data

; Clamp at 0xFF.
    LDAA    #$FF

.store_scaling_curve_data:
    LDX     <copy_ptr_dest
    STAA    0,x
    INX
    STX     <copy_ptr_dest

    PULB
    INCB
    CMPB    #29
    BNE     .create_scaling_curve_loop

    RTS

table_operator_keyboard_scaling_level_below_20:
    DC.B $7F, $7A, $76, $72, $6E
    DC.B $6B, $68, $66, $64, $62
    DC.B $60, $5E, $5C, $5A, $58
    DC.B $56, $55, $54, $52, $51

; =============================================================================
; Exponential Keyboard Scaling Curve
; =============================================================================
table_operator_keyboard_scaling_level:
    DC.B 0, 1, 2, 3, 4, 5, 6
    DC.B 7, 8, 9, $B, $E, $10
    DC.B $13, $17, $1C, $21, $27
    DC.B $2F, $39, $43, $50, $5F
    DC.B $71, $86, $A0, $BE, $E0
    DC.B $FF


; =============================================================================
; VOICE_SET_KEY_TRANSPOSE_BASE_FREQUENCY
; =============================================================================
; LOCATION: 0xD392
;
; DESCRIPTION:
; This subroutine calculates the 'key transpose' base logarithmic frequency.
; This value is used in calculating the final frequency value for notes sent
; to the EGS chip.
;
; This differs from the method used in the DX7. The DX7 simply adds the base
; transpose note to each note number being played.
;
; This method is identical to the method of calculating the logarithmic note
; frequency used in the main 'Note On' handler.
;
; =============================================================================
voice_set_key_transpose_base_frequency:         SUBROUTINE
    LDAB    patch_edit_key_transpose
    ADDB    #48
    LDX     #table_midi_key_to_log_f
    ABX
    LDAA    0,x
    STAA    <note_frequency

; Create the lower-byte of the 14-bit logarithmic frequency.
    LDAB    #3
    ANDA    #%11
    STAA    <note_frequency_low

; This loop calculates the LSB of the key transpose base frequency.
; This method is identical to the method of calculating the note frequency.
.create_lsb_loop:
    ORAA    <note_frequency_low
    ASLA
    ASLA
    DECB
    BNE     .create_lsb_loop

    STAA    <note_frequency_low
    LDD     <note_frequency

; @TODO: What is this value?
; It seems to correspond to octave 19.
    SUBD    #$4EA8
    STD     <note_transpose_frequency_base

    RTS


; =============================================================================
; PORTAMENTO_CALCULATE_RATE
; =============================================================================
; LOCATION: 0xD3B6
;
; DESCRIPTION:
; Calculates the correct portamento frequency increment corresponding to a
; patch's portamento time.
; This value is then stored internally, and used in various voice-related
; calculations.
;
; =============================================================================
portamento_calculate_rate:                      SUBROUTINE
    LDAB    portamento_time
    LDX     #table_portamento_time
    ABX
    LDAB    0,x
    STAB    <portamento_rate_scaled

    RTS

table_portamento_time:
    DC.B $FF, $FE, $F3, $E8, $D3
    DC.B $CA, $C1, $B9, $B2, $AB
    DC.B $A5, $9F, $99, $93, $8D
    DC.B $87, $82, $7D, $78, $73
    DC.B $6E, $6A, $66, $62, $5E
    DC.B $5B, $58, $55, $52, $4F
    DC.B $4C, $4A, $48, $46, $44
    DC.B $42, $40, $3E, $3C, $3A
    DC.B $38, $36, $35, $33, $31
    DC.B $2F, $2E, $2C, $2A, $29
    DC.B $27, $26, $25, $24, $22
    DC.B $21, $1F, $1E, $1C, $1B
    DC.B $1A, $19, $18, $17, $16
    DC.B $15, $14, $13, $12, $12
    DC.B $11, $10, $10, $F, $E
    DC.B $E, $D, $D, $C, $C, $B
    DC.B $B, $A, $A, 9, 9, 8
    DC.B 8, 7, 7, 6, 6, 5, 5
    DC.B 4, 4, 3, 3, 2, 1


; =============================================================================
; PATCH_COPY_TO_TAPE_BUFFER
; =============================================================================
; LOCATION: 0xD426
;
; DESCRIPTION:
; Copies a patch from the synth's internal memory into the temporary tape
; buffer, prior to being output via the cassette interface.
;
; ARGUMENTS:
; Registers:
; * ACCA: The patch number to copy, indexed from 0.
;
; =============================================================================
patch_copy_to_tape_buffer:                      SUBROUTINE
    LDAB    #64
    MUL
    ADDD    #patch_buffer
    STD     <copy_ptr_src
    LDX     #patch_buffer_tape_temp
    STX     <copy_ptr_dest
    BRA     patch_copy


; =============================================================================
; PATCH_COPY_FROM_TAPE_BUFFER
; =============================================================================
; LOCATION: 0xD435
;
; DESCRIPTION:
; Copies a patch from the synth's temporary tape buffer into the synth's
; internal memory, after being received via the cassette interface.
;
; ARGUMENTS:
; Registers:
; * ACCA: The patch number to copy to, indexed from 0.
;
; =============================================================================
patch_copy_from_tape_buffer:                    SUBROUTINE
    LDX     #patch_buffer_tape_temp
    STX     <copy_ptr_src
    LDAB    #64
    MUL
    ADDD    #patch_buffer
    STD     <copy_ptr_dest
    BRA     patch_copy

; =============================================================================
; PATCH_COPY
; =============================================================================
; DESCRIPTION:
; Used to copy a patch to, or from the tape patch buffer.
;
; Memory:
; * copy_ptr_src:  A pointer to the source patch data.
; * copy_ptr_dest: A pointer to the destination address to copy to.
;
; =============================================================================
patch_copy:                                     SUBROUTINE
    LDAB    #32
    STAB    <copy_counter

.patch_copy_loop:
    LDX     <copy_ptr_src
    LDD     0,x
    INX
    INX
    STX     <copy_ptr_src
    LDX     <copy_ptr_dest
    STD     0,x
    INX
    INX
    STX     <copy_ptr_dest
    DEC     copy_counter
    BNE     .patch_copy_loop

    RTS


; =============================================================================
; VOICE_ADD_LOAD_OPERATOR_LEVEL_VOICE_FREQ_TO_EGS
; =============================================================================
; LOCATION: 0xD45E
;
; DESCRIPTION:
; Loads the operator level, and frequency for a new note to the EGS chip.
; Tests whether the current portamento settings mean the new note frequency
; should not be loaded immediately.
;
; ARGUMENTS:
; Registers:
; * IX:   The frequency for the new note.
; * ACCA: The zero-indexed voice number.
;
; =============================================================================
voice_add_load_op_level_voice_freq_to_egs:      SUBROUTINE
    STX     <egs_load_freq_note_freq
    STAA    <egs_load_freq_voice_number
    CLRB
    STAB    <egs_load_freq_operator_index

.load_operator_levels_loop:
; The following section calculates the final level of each operator, based
; upon the operator keyboard scaling settings, and writes the final level
; value to the EGS chip.
; The final level is calculated by computing an index into the pre-calculated
; scaling level table, based upon the note frequency.
    LDX     #operator_4_enabled_status

; Get the one's complement negation of ACCB to invert the index order
; from 0-3 to 3-0.
    COMB
    ANDB    #%11
    ABX

; Load the individual operator enabled status.
    LDAA    0,x
    ANDA    #1
    BNE     .operator_enabled

; If the operator is disabled, set the volume to 0xFF.
    LDAA    #$FF
    BRA     .write_operator_level_to_egs

.operator_enabled:
; Calculate the starting index into the operator keyboard scaling table,
; based upon the operator number.
    LDX     #operator_keyboard_scaling_level_curve_table
    LDAB    <egs_load_freq_operator_index
    LDAA    #29
    MUL
    ABX

; Calculate the index into the keyboard scaling curve based upon the
; frequency of the note being added.
    LDAB    <egs_load_freq_note_freq
    ADDB    #32
    ADDB    <note_transpose_frequency_base

; Subtract 62, and clamp at 0 if the result is negative.
    SUBB    #62
    BCC     .is_voice_frequency_above_scaling_limit

    CLRB

.is_voice_frequency_above_scaling_limit:
; If this value is above 112, clamp.
    CMPB    #112
    BLS     .get_index_into_keybord_scaling_table

    LDAB    #112

.get_index_into_keybord_scaling_table:
; Shift the resulting value twice to the right to reduce it to a valid
; index between 0-28, the range of the operator keyboard scaling array.
; Load the operator keyboard scaling level from the array.
; Add 2 to this value, and if it overflows, clamp at 0xFF.
    LSRB
    LSRB
    ABX
    LDAA    0,x
    ADDA    #2
    BCC     .write_operator_level_to_egs

    LDAA    #$FF

.write_operator_level_to_egs:
    PSHA
    LDX     #egs_operator_level

; Multiply the index by 16, since there are 16 entries per operator.
; Then add the index of the voice being added.
    LDAA    #16
    LDAB    <egs_load_freq_operator_index
    MUL
    ADDB    <egs_load_freq_voice_number
    ABX

; Write the calculated operator level to the EGS.
    PULA
    STAA    0,x
    LDAB    <egs_load_freq_operator_index
    INCB
    STAB    <egs_load_freq_operator_index

; Check if all operator levels have been loaded.
    CMPB    #4
    BNE     .load_operator_levels_loop

; Load the frequency of the new note to the EGS.
; Test if the synth is in Monophonic mode. If so, test the portamento
; mode to determine whether the new note's frequency should be loaded
; immediately, or whether it should be updated in the portamento routine.
    TST     mono_poly

; Branch if the synth is in mono mode.
    BNE     .synth_is_mono

.is_porta_pedal_active:
; Test whether the portamento pedal is active.
; If not, proceed to loading the new frequency immediately.
    TIMD    #PEDAL_INPUT_PORTA, pedal_status_current
    BEQ     .write_voice_frequency_to_egs

; Test whether the portamento increment is at its maximum, and therefore
; the pitch transition would be immediate.
; If not, don't add the new note frequency. It will be added by the portamento
; processing function.
    LDAA    <portamento_rate_scaled
    CMPA    #$FF
    BNE     .exit

.write_voice_frequency_to_egs:
    LDX     #egs_voice_frequency
    LDAB    <egs_load_freq_voice_number
    ASLB
    ABX

; Calculate the final logarithmic frequency value to load to the EGS.
    CLRA
    LDAB    master_tune
    LSLD
    LSLD
    ADDD    <note_transpose_frequency_base
    ADDD    <egs_load_freq_note_freq
    ADDD    #$2458

; Store the voice pitch to the EGS chip.
    STAA    0,x
    STAB    1,x

.exit:
    RTS

.synth_is_mono:
; Test whether the portamento mode is 'Fingered'.
; If so, load the new note's frequency immediately.
    TST     portamento_mode
    BEQ     .is_porta_pedal_active

    BRA     .write_voice_frequency_to_egs


; =============================================================================
; VOICE_UDPATE_SUSTAIN_STATUS
; =============================================================================
; LOCATION: 0xD4E3
;
; DESCRIPTION:
; Tests to see whether the status of the sustain pedal has changed, and if so,
; whether it has changed to an inactive state. If this is the case, this
; subroutine tests all voices to determine if they are currently sustained,
; and if so sends an update to the EGS to end the sustain.
;
; =============================================================================
voice_update_sustain_status:                    SUBROUTINE
; Mask the sustain pedal status.
    LDAA    <pedal_status_current
    ANDA    #PEDAL_INPUT_SUSTAIN
    PSHA

; Invert the sustain pedal status, and perform a logical AND between the
; inverted updated status, and the previous.
; If the result is 1 it indicates that the sustain pedal status has changed
; from an 'On' state, to an 'Off' state.
    COMA
    ANDA    <sustain_status
    BEQ     .save_sustain_status_and_exit

; If the sustain pedal has transitioned to inactive, send an 'Off' event for
; each voice to the EGS to disable sustain.
    LDX     #voice_status
    LDAB    #EGS_VOICE_EVENT_OFF

; Test each voice to determine if they are marked as being sustained.
; If so, update the voice status array, and send the voice event signal to
; the EGS turn the voice off.
.test_for_sustained_voices_loop:
    TIMX    #VOICE_STATUS_SUSTAIN, 1,x
    BEQ     .advance_sustain_test_loop

    STAB    egs_key_event
    DELAY_SHORT

.advance_sustain_test_loop:
    INX
    INX

; Since the voice number field is stored in bits 2-5, increment the index by
; four to increment the voice number.
    ADDB    #4
    CMPB    #66
    BNE     .test_for_sustained_voices_loop

.save_sustain_status_and_exit:
    PULA
    STAA    <sustain_status

    RTS


; =============================================================================
; PITCH_BEND_PROCESS
; =============================================================================
; DESCRIPTION:
; Updates the 'Pitch Bend base frequency' periodically as part of the OCF
; interrupt handler. This frequency is loaded to the EGS' pitch modulation
; register as part of the pitch modulation update routine.
;
; ARGUMENTS:
; Memory:
; * analog_input_pitch_bend: The front-panel pitch bender's analog input.
;
; =============================================================================
pitch_bend_process:                             SUBROUTINE
; This XOR operation converts a positive polarity value to a value in the range
; of 0 and 127, and a negative polarity value to a value between 0 and -127.
    LDAA    analog_input_pitch_bend
    EORA    #%10000000

; The values 1, and 0xFF are ignored.
; These values are 1 unit away from the resting point. This operation is likely
; used as a filter against spurious reads.
    CMPA    #1
    BGT     .store_value_with_correct_polarity

    CMPA    #$FF
    BLT     .store_value_with_correct_polarity

; If the value previously read was '1' unit away from the zero point, clear it.
    CLRA

.store_value_with_correct_polarity:
    STAA    <pitch_bend_amount

; Use the pitch bend range value as an index to load the maximum pitch bend
; amount from the table.
    LDX     #table_pitch_bend_range_scale
    LDAB    pitch_bend_range
    ABX
    LDAB    0,x

; Test if the pitch bend range is at the maximum possible amount.
    CMPB    #$FF
    BNE     .scale_pitch_bend_input_by_range

; Test if the front-panel pitch bend wheel input is at the maximum positive,
; or negative value.
    CMPA    #$7F
    BEQ     .scale_pitch_bend_and_store

    CMPA    #$80
    BEQ     .scale_pitch_bend_and_store

; If the pitch bend range value is at its maximum possible value, and the
; front-panel wheel input is at the maximum positive or negative value, clear
; the range value, since no scaling is necessary.
    CLRB

.scale_pitch_bend_and_store:
    LSRD
    BRA     .is_pitch_bend_positive

.scale_pitch_bend_input_by_range:
; This section scales the pitch bend input amount by the specified range.
; Test if bit 7 is set, indicating the bend polarity is negative.
    TSTA
    BMI     .bend_polarity_is_negative

    ASLA
    MUL
    BRA     .scale_value

.bend_polarity_is_negative:
; Invert the value, since a value of 0xFF is the resting point of the front
; panel pitch-bend wheel.
    COMA

    ASLA
    MUL
    COMA
    COMB

.scale_value:
    LSRD
    LSRD

.is_pitch_bend_positive:
    TST     pitch_bend_amount
    BPL     .store_frequency_and_exit

    ORAA    #%11000000

.store_frequency_and_exit:
    STD     <pitch_bend_frequency

    RTS


; =============================================================================
; This table contains the coefficient corresponding to the pitch bend range by
; which the front-panel pitch bend wheel input value is scaled to yield the
; final pitch modulation amount.
; =============================================================================
table_pitch_bend_range_scale:
    DC.B 0
    DC.B $16
    DC.B $2B
    DC.B $41
    DC.B $56
    DC.B $6B
    DC.B $81
    DC.B $97
    DC.B $AC
    DC.B $C2
    DC.B $D7
    DC.B $EC
    DC.B $FF


; =============================================================================
; PORTAMENTO_PROCESS
; =============================================================================
; DESCRIPTION:
; This subroutine is where the current portamento frequency for each of the
; synth's voices is updated, and loaded to the EGS chip.
; This is called periodically as part of the OCF interrupt routine.
; @NOTE: In the DX7 ROM this subroutine processes half of the synth's
; 16 voices with each call, alternating each time.
; In the DX9 ROM this subroutine is called once every two interrupts.
;
; =============================================================================
portamento_process:                             SUBROUTINE
; Convert the master tune setting to its correct, logarithmic value.
    CLRA
    LDAB    master_tune
    LSLD
    LSLD
; Add the transpose frequency base, and this constant value.
    ADDD    <note_transpose_frequency_base
    ADDD    #$2458
    STD     <portamento_frequency_base

    LDX     #(voice_frequency_target + 30)
    LDAB    #15
    STAB    <portamento_process_loop_counter

; If the synth is poly, the portamento mode is ignored.
    TST     mono_poly
    BEQ     .is_portamento_pedal_active

; If the synth is in mono mode, test whether the portamento mode is
; 'Fingered', in which case ignore whether the portamento pedal is depressed.
    TST     portamento_mode
    BNE     .process_voice_loop

.is_portamento_pedal_active:
    TIMD    #PEDAL_INPUT_PORTA, pedal_status_current
    BEQ     .portamento_inactive

.process_voice_loop:
; Load the current voice's target frequency and subtract the current frequency.
    LDD     0,x
    STD     <portamento_process_voice_target_frequency
    SUBD    32,x

    BEQ     .pitch_transition_is_instantaneous

; If the difference is positive, the portamento is moving downwards.
    BPL     .portamento_direction_down

; Otherwise the portamento direction is upwards.
; Test whether the portamento rate is instantaneous.
    LDAB    <portamento_rate_scaled
    CMPB    #$FF
    BEQ     .pitch_transition_is_instantaneous

; Calculate the portamento increment.
    NEGA
    LSRA
    LSRA
    INCA
    MUL
    STD     <portamento_process_frequency_increment

; Subtract the increment value from the current frequency, and test whether
; the total difference is less than the increment.
; If so, the pitch transition is instantaneous.
    LDD     32,x
    SUBD    <portamento_process_frequency_increment
    XGDX
    CPX     <portamento_process_voice_target_frequency
    XGDX
    BCC     .update_current_voice_frequency

    BRA     .pitch_transition_is_instantaneous

.portamento_direction_down:
; Test whether the portamento rate is instantaneous.
    LDAB    <portamento_rate_scaled
    CMPB    #$FF
    BEQ     .pitch_transition_is_instantaneous

; Calculate the portamento decrement.
    LSRA
    LSRA
    INCA
    MUL

; Add the increment value to the current frequency, and test whether the total
; difference is less than the increment.
; If so, the pitch transition is instantaneous.
    ADDD    32,x
    XGDX
    CPX     <portamento_process_voice_target_frequency
    XGDX
    BCS     .update_current_voice_frequency

.pitch_transition_is_instantaneous:
    LDD     <portamento_process_voice_target_frequency

.update_current_voice_frequency:
; Update the current voice frequency,
    STD     32,x
    ADDD    <portamento_frequency_base
; Write this frequency to the EGS' voice frequency register.
    STAA    64,x
    STAB    65,x

    DEX
    DEX
    DEC     portamento_process_loop_counter
    BPL     .process_voice_loop

    RTS

.portamento_inactive:
; Set the voice's current frequency to match the target frequency immediately.
    LDD     0,x
    STD     32,x
    ADDD    <portamento_frequency_base

; Write these values to the EGS voice frequency register.
    STAA    64,x
    STAB    65,x

    DEX
    DEX
    DEC     portamento_process_loop_counter
    BPL     .portamento_inactive

    RTS


; =============================================================================
; LFO_PROCESS
; =============================================================================
; LOCATION: 0xD5D2
;
; DESCRIPTION:
; Calculates, and stores the instantaneous amplitude of the synth's LFO at its
; current phase, depending on the LFO delay, and LFO type.
;
; =============================================================================
lfo_process:                                    SUBROUTINE
    LDD     <lfo_delay_accumulator
    ADDD    <lfo_delay_increment

; After adding the increment, does this overflow?
; If the carry bit is set on account of the delay accumulator overflowing,
; clamp the LFO delay accumulator at 0xFFFF.
    BCC     .store_delay_accumulator

; If the LFO delay accumulator has overflowed its 16-bit register, then
; the 'Fade In' accumulator becomes active. This counter constitutes a
; 'scale factor' for the overall LFO modulation amount.
; The LFO delay accumulator is clamped at 0xFFFF. Once this
; value overflows 16-bits once it is effectively locked at 0xFFFF until
; reset by the voice add trigger.
    LDD     #$FFFF

.store_delay_accumulator:
    STD     <lfo_delay_accumulator

; Test whether the LFO Delay accumulator is at its maximum (0xFFFF), by adding
; '1', and testing whether the result overflows.
; If so, process the delay fadein factor.
    ADDD    #1
    BNE     .increment_accumulator

    LDD     <lfo_delay_fadein_factor
    ADDD    <lfo_delay_increment
    BCC     .store_fadein_factor

    LDD     #$FFFF

.store_fadein_factor:
    STD     <lfo_delay_fadein_factor

.increment_accumulator:
; Increment the LFO phase accumulator.
    LDD     <lfo_phase_accumulator
    ADDD    <lfo_phase_increment

; If the LFO phase accumulator overflows after adding the LFO phase
; increment, set the flag to update the Sample and Hold LFO amplitude.
    BVC     .update_sample_and_hold
    OIMD    #%10000000, lfo_sample_and_hold_update_flag
    BRA     .store_phase_accumulator

.update_sample_and_hold:
    AIMD    #%1111111, lfo_sample_and_hold_update_flag

.store_phase_accumulator:
    STD     <lfo_phase_accumulator

; Jumpoff to the specific LFO shape functions.
    LDAB    lfo_waveform
    ANDB    #%111
    JSR     jumpoff_indexed

    DC.B lfo_process_tri - *
    DC.B lfo_process_saw_down - *
    DC.B lfo_process_saw_up - *
    DC.B lfo_process_square - *
    DC.B lfo_process_sin - *
    DC.B lfo_process_sh - *
    DC.B lfo_process_sh - *
    DC.B lfo_process_sh - *


; =============================================================================
; LFO_PROCESS_TRI
; =============================================================================
; LOCATION: 0xD60D
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Triangle' shape is selected.
; This computes, and stores the final LFO amplitude, which is used in the
; various modulation processes.
;
; =============================================================================
lfo_process_tri:                                SUBROUTINE
    LDD     <lfo_phase_accumulator

; For the Triangle LFO The two-byte LFO phase accumulator is shifted to the
; left. If the carry bit is set, it indicates that the accumulator is in the
; second half of its full period. In this case the one's complement of the
; accumulator's MSB  is taken to invert the wave vertically.
; 128 is then added to centre the wave vertically around 0.
    LSLD
    BCC     .center_triangle_and_store

    COMA

.center_triangle_and_store:
; Add 0x80 so that the wave is correctly oriented vertically, with 0 as the
; 'centre' value.
    ADDA    #$80
    BRA     lfo_process_store_amplitude


; =============================================================================
; LFO_PROCESS_SAW_DOWN
; =============================================================================
; LOCATION: 0xD617
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Saw Down' shape is selected.
; The LFO phase accumulator register can be inverted to achieve a decreasing
; saw wave.
;
; =============================================================================
lfo_process_saw_down:                           SUBROUTINE
    COMA
; falls-through below.

; =============================================================================
; LFO_PROCESS_SAW_UP
; =============================================================================
; LOCATION: 0xD618
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Saw Up' shape is selected.
; The most-significant byte of the LFO phase accumulator register can be used
; as an increasing saw wave value.
;
; =============================================================================
lfo_process_saw_up:                             SUBROUTINE
    BRA     lfo_process_store_amplitude


; =============================================================================
; LFO_PROCESS_SQUARE
; =============================================================================
; LOCATION: 0xD61A
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Square' shape is selected.
;
; =============================================================================
lfo_process_square:                             SUBROUTINE
; Perform a logical AND operation with the most significant bit of the
; phase accumulator MSB to determine whether it is in the first or second
; half of its full period.
; If it is in the first half, return a positive polarity signal (127).
; If not, return a negative polarity.
    ANDA    #%10000000
    BMI     .store_value

    LDAA    #$7F

.store_value:
    BRA     lfo_process_store_amplitude


; =============================================================================
; LFO_PROCESS_SIN
; =============================================================================
; LOCATION: 0xD622
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Sine' shape is selected.
;
; =============================================================================
lfo_process_sin:                                SUBROUTINE
    TAB

; The following sequence computes the index into the Sine LFO LUT.
; This performs a modulo operation limiting the accumulator to the length of
; the sine table (64), and then inverts the resulting index horizontally if
; the accumulator value had bit 6 set.
; The corresponding instantaneous amplitude is then looked up in the Sine LFO
; table. If bit 7 of the accumulator's MSB is set, indicating that the
; accumulator was in the second-half of its phase, then the one's complement
; of the amplitude is computed to invert the amplitude.
    ANDB    #%111111
    BITA    #%1000000
    BEQ     .lookup_value

    EORB    #%111111

.lookup_value:
    LDX     #table_lfo_sin
    ABX
    LDAB    0,x
    TSTA

; If bit 7 of the accumulator MSB is set, indicating the LFO is in the
; second-half of its phase, then invert the wave amplitude.
    BPL     .store_value

    COMB

.store_value:
    TBA
    BRA     lfo_process_store_amplitude


; =============================================================================
; LFO_PROCESS_SH
; =============================================================================
; LOCATION: 0xD638
;
; DESCRIPTION:
; Calculates the instantaneous amplitude of the synth's LFO at its current
; phase when the 'Sample and Hold' shape is selected.
;
; =============================================================================
lfo_process_sh:                                 SUBROUTINE
; Test the 'S+H Update Flag' to determine whether a new 'random' Sample+Hold
; value needs to be sampled.
    TST     lfo_sample_and_hold_update_flag

; If the MSB is set, then the 'Sample+Hold Accumulator' register is multiplied
; by a prime number (179), and the lower-byte has another prime (17) added to
; it. The effect is an inexpensive pseudo-random value.
    BPL     lfo_process_exit
    LDAA    lfo_sample_hold_accumulator
    LDAB    #179
    MUL
    ADDB    #17
    STAB    lfo_sample_hold_accumulator
    TBA
; falls-through below.

; =============================================================================
; LFO_PROCESS_STORE_AMPLITUDE
; =============================================================================
; DESCRIPTION:
; This is where the final calculated amplitude for the LFO is stored.
; This is essentially the end of the LFO processing subroutines. All of the
; LFO subroutines eventually terminate here, with the exception of when the
; Sample+Hold subroutine exits early.
;
; =============================================================================
lfo_process_store_amplitude:                    SUBROUTINE
    STAA    <lfo_amplitude

lfo_process_exit:
    RTS

; =============================================================================
; LFO Sine Lookup Table
; Length: 64
; =============================================================================
table_lfo_sin:
    DC.B 2, 5, 8, $B, $E, $11
    DC.B $14, $17, $1A, $1D, $20
    DC.B $23, $26, $29, $2C, $2F
    DC.B $32, $35, $38, $3A, $3D
    DC.B $40, $43, $45, $48, $4A
    DC.B $4D, $4F, $52, $54, $56
    DC.B $59, $5B, $5D, $5F, $61
    DC.B $63, $65, $67, $69, $6A
    DC.B $6C, $6E, $6F, $71, $72
    DC.B $73, $75, $76, $77, $78
    DC.B $79, $7A, $7B, $7C, $7C
    DC.B $7C, $7D, $7D, $7E, $7E
    DC.B $7F, $7F, $7F


; =============================================================================
; MOD_AMP_UPDATE
; =============================================================================
; LOCATION: 0xD698
;
; DESCRIPTION:
; This subroutine calculates the total amplitude modulation input.
; This tests the various modulation sources (Mod Wheel/Breath Controller) for
; whether EG Bias is enabled, and contributes their input accordingly.
; The overall arithmetic formula used here isn't well understood.
; It's totally arbitrary, and calculates the index into a LUT, from which the
; value sent to the EGS is retrieved.
;
; =============================================================================
mod_amp_update:                                 SUBROUTINE
; Scale the mod wheel input by its specified range.
    LDAA    mod_wheel_range
    JSR     patch_convert_serialised_value_to_internal
    LDAB    analog_input_mod_wheel
    MUL
    STAA    <mod_wheel_input_scaled

; Scale the breath controller input by its specified range.
    LDAA    breath_control_range
    JSR     patch_convert_serialised_value_to_internal
    LDAB    analog_input_breath_controller
    MUL
    STAA    <breath_controller_input_scaled

; Set up EG Bias offset.
; The effect of the following code is that if the EG Bias for a particular
; modulation source (Mod Wheel/Breath Controller) is enabled, the range for
; that source will contribute to the total modulation amount.
    CLRA

    TST     mod_wheel_eg_bias
    BEQ     .is_breath_control_eg_bias_enabled

; Convert the 0-99 variable range to 0-255.
    LDAA    mod_wheel_range
    JSR     patch_convert_serialised_value_to_internal

.is_breath_control_eg_bias_enabled:
    TST     breath_control_eg_bias
    BEQ     .store_total_bias_amount

    STAA    <mod_amount_total

; Convert the 0-99 variable range to 0-255.
    LDAA    breath_control_range
    JSR     patch_convert_serialised_value_to_internal

    ADDA    <mod_amount_total
    BCC     .store_total_bias_amount

    LDAA    #$FF        ; Clamp at 0xFF.

.store_total_bias_amount:
    COMA
    STAA    <mod_amount_total

; Set up the EG Biased input.
; The following section tests whether EG Bias is enabled for a particular
; source. If so, the scaled input is added to the total.
    CLRA

; If EG Bias for this modulation source is enabled, add the scaled input value.
    TST     mod_wheel_eg_bias
    BEQ     .is_breath_control_eg_bias_enabled_2

    LDAA    <mod_wheel_input_scaled

.is_breath_control_eg_bias_enabled_2:
; If EG Bias for this modulation source is enabled, add the scaled input value.
    TST     breath_control_eg_bias
    BEQ     .add_current_total_to_bias_input

    ADDA    <breath_controller_input_scaled
    BCC     .add_current_total_to_bias_input

    LDAA    #$FF        ; Clamp at 0xFF.

.add_current_total_to_bias_input:
    ADDA    <mod_amount_total
    BCC     .store_total_with_bias_input

    LDAA    #$FF        ; Clamp at 0xFF.

.store_total_with_bias_input:
    COMA
    STAA    <mod_amount_total

; Test whether amplitude modulation is enabled for each modulation source.
; If so, the scaled input for each is added to the total amp modulation input.
    CLRA
    TST     mod_wheel_amp
    BEQ     .is_breath_control_amp_mod_enabled

    LDAA    <mod_wheel_input_scaled

.is_breath_control_amp_mod_enabled:
    TST     breath_control_amp
    BEQ     .get_scaled_lfo_depth_factor

    ADDA    <breath_controller_input_scaled
    BCC     .get_scaled_lfo_depth_factor

    LDAA    #$FF        ; Clamp at 0xFF.

; The following section calculates the total LFO amp modulation.

.get_scaled_lfo_depth_factor:
; Scale the LFO amp modulation depth by the LFO scale-in factor.
    PSHA
    LDAA    <lfo_mod_depth_amp
    LDAB    <lfo_delay_fadein_factor
    MUL

    PULB
    ABA
    BCC     .add_scaled_lfo_fadein_factor_to_total

    LDAA    #$FF        ; Clamp at 0xFF.

.add_scaled_lfo_fadein_factor_to_total:
    ADDA    <mod_amount_total
    BCC     .calculate_lfo_amp_mod

    LDAA    #$FF        ; Clamp at 0xFF.

.calculate_lfo_amp_mod:
    SUBA    <mod_amount_total

; Invert the LFO amplitude by getting a one's complement of the value,
; and then inverting the sign-bit.
    LDAB    <lfo_amplitude
    COMB
    EORB    #$80

    MUL
    ADDA    <mod_amount_total
    BCC     .write_amp_mod_to_egs

    LDAA    #$FF        ; Clamp at 0xFF.

.write_amp_mod_to_egs:
    COMA

    LDX     #table_egs_amp_mod_input
    TAB
    ABX
    LDAA    0,x
    STAA    egs_amp_mod

    RTS

; =============================================================================
; This lookup table contains the values sent to the EGS Amplitude Modulation
; register. Refer to the 'Yamaha DX7 Technical Analysis' document page 63 for a
; detailed look at what level of modulation the final values correspond to.
; =============================================================================
table_egs_amp_mod_input:
    DC.B $FF, $FF, $E0, $CD, $C0
    DC.B $B5, $AD, $A6, $A0, $9A
    DC.B $95, $91, $8D, $89, $86
    DC.B $82, $80, $7D, $7A, $78
    DC.B $75, $73, $71, $6F, $6D
    DC.B $6B, $69, $67, $66, $64
    DC.B $62, $61, $60, $5E, $5D
    DC.B $5B, $5A, $59, $58, $56
    DC.B $55, $54, $53, $52, $51
    DC.B $50, $4F, $4E, $4D, $4C
    DC.B $4B, $4A, $49, $48, $47
    DC.B $46, $46, $45, $44, $43
    DC.B $42, $42, $41, $40, $40
    DC.B $3F, $3E, $3D, $3D, $3C
    DC.B $3B, $3B, $3A, $39, $39
    DC.B $38, $38, $37, $36, $36
    DC.B $35, $35, $34, $33, $33
    DC.B $32, $32, $31, $31, $30
    DC.B $30, $2F, $2F, $2E, $2E
    DC.B $2D, $2D, $2C, $2C, $2B
    DC.B $2B, $2A, $2A, $2A, $29
    DC.B $29, $28, $28, $27, $27
    DC.B $26, $26, $26, $25, $25
    DC.B $24, $24, $24, $23, $23
    DC.B $22, $22, $22, $21, $21
    DC.B $21, $20, $20, $20, $1F
    DC.B $1F, $1E, $1E, $1E, $1D
    DC.B $1D, $1D, $1C, $1C, $1C
    DC.B $1B, $1B, $1B, $1A, $1A
    DC.B $1A, $19, $19, $19, $18
    DC.B $18, $18, $18, $17, $17
    DC.B $17, $16, $16, $16, $15
    DC.B $15, $15, $15, $14, $14
    DC.B $14, $13, $13, $13, $13
    DC.B $12, $12, $12, $12, $11
    DC.B $11, $11, $11, $10, $10
    DC.B $10, $10, $F, $F, $F
    DC.B $F, $E, $E, $E, $E, $D
    DC.B $D, $D, $D, $C, $C, $C
    DC.B $C, $B, $B, $B, $B, $A
    DC.B $A, $A, $A, 9, 9, 9
    DC.B 9, 8, 8, 8, 8, 8, 7
    DC.B 7, 7, 7, 6, 6, 6, 6
    DC.B 6, 5, 5, 5, 5, 5, 4
    DC.B 4, 4, 4, 4, 3, 3, 3
    DC.B 3, 3, 2, 2, 2, 2, 2
    DC.B 2, 1, 1, 1, 1, 1, 0
    DC.B 0, 0, 0, 0, 0


; =============================================================================
; MOD_PITCH_UPDATE
; =============================================================================
; LOCATION: 0xD821
;
; DESCRIPTION:
; Calculates the final pitch modulation amount, and writes it to the
; associated EGS register.
;
; =============================================================================
mod_pitch_update:                               SUBROUTINE
    CLRA

; If the mod wheel is not assigned to any modulation destination, store '0' for
; the scaled mod wheel input.
    TST     mod_wheel_assign
    BEQ     .store_scaled_mod_wheel_input

    LDAA    mod_wheel_range
    JSR     patch_convert_serialised_value_to_internal
    LDAB    analog_input_mod_wheel
    MUL

.store_scaled_mod_wheel_input:
    STAA    <mod_wheel_input_scaled

    TST     breath_control_assign
    BEQ     .get_scaled_lfo_depth_factor

    LDAA    breath_control_range
    JSR     patch_convert_serialised_value_to_internal
    LDAB    analog_input_breath_controller
    MUL
    ADDA    <mod_wheel_input_scaled
    BCC     .get_scaled_lfo_depth_factor

; If this value overflows, clamp at 0xFF.
    LDAA    #$FF

.get_scaled_lfo_depth_factor:
; ACCA now contains the sum of the scaled mod wheel, and breath controller
; inputs. Clamped at 0xFF.
    PSHA

    LDAA    <lfo_mod_depth_pitch
    LDAB    <lfo_delay_fadein_factor
    MUL

; Get the total LFO modulation factor in ACCA. This is the lfo delay fade-in
; factor multiplied with the modulation depth.
; Restore the scaled modulation input to ACCB.
    PULB
; Add these together, and clamp at 0xFF.
    ABA
    BCC     .scale_by_lfo_amplitude

    LDAA    #$FF

.scale_by_lfo_amplitude:
    PSHA
    LDAA    lfo_pitch_mod_sensitivity
    LDAB    <lfo_amplitude
    BMI     .lfo_amplitude_negative

    MUL
    PULB
    MUL
    BRA     .write_pitch_mod_to_egs

.lfo_amplitude_negative:
    NEGB
    MUL
    PULB
    MUL
    COMA
    COMB
    ADDD    #1

.write_pitch_mod_to_egs:
    ASRA
    rorb
    ADDD    <pitch_bend_frequency
    STAA    egs_pitch_mod_high
    STAB    egs_pitch_mod_low

    RTS


; =============================================================================
; LED_COMPARE_MODE_BLINK
; =============================================================================
; LOCATION: 0xD875
;
; DESCRIPTION:
; Facilitates the 'blinking' of the LED panel when the synth is in 'compare
; patch' mode.
;
; =============================================================================
handler_ocf_compare_mode_led_blink:             SUBROUTINE
    TST     patch_compare_mode_active
    BNE     .compare_mode_active

    CLR     led_compare_mode_blink_counter
    BRA     .exit

.compare_mode_active:
; If the compare mode is active, test whether the counter's low 5 bits are
; equal to zero. If not, increment the counter and exit.
    LDAA    led_compare_mode_blink_counter
    ANDA    #%11111
    BNE     .increment_counter

; If the counter's low bits are zero, test whether bit 5 is high.
; If so, show the patch number.
    LDAA    #%100000
    ANDA    led_compare_mode_blink_counter
    BNE     .print_patch_number

; Otherwise clear the LED display.
    LDD     #$FFFF
    BRA     .store_led_contents

.print_patch_number:
    LDD     led_contents

.store_led_contents:
    STD     <led_1

.increment_counter:
    INC     led_compare_mode_blink_counter

.exit:
    RTS


; =============================================================================
; ACTIVE_SENSING_UPDATE_TX_COUNTER
; =============================================================================
; LOCATION: 0xD89B
;
; DESCRIPTION:
; This subroutine is run as part of the periodic 'OCF' interrupt.
; Updates the active sensing transmit counter. If the counter reaches '64',
; then the flag to send an active sensing pulse is set.
;
; =============================================================================
active_sensing_update_tx_counter:               SUBROUTINE
    INC     midi_active_sensing_tx_counter

; Test whether this counter byte has reached 64.
; If so, clear.
    TIMD    #%1000000, midi_active_sensing_tx_counter
    BEQ     .exit

    CLR     midi_active_sensing_tx_pending_flag
    CLR     midi_active_sensing_tx_counter

.exit:
    RTS


; =============================================================================
; HANDLER_OCF_SYSEX_VOICE_TIMEOUT
; =============================================================================
; LOCATION: 0xD8AA
;
; DESCRIPTION:
; This subroutine is run as part of the periodic 'OCF' interrupt.
; When the synth is receiving SysEx data this function will count up to
; 255 invocations, and then reset the synth's voice parameters.
;
; =============================================================================
handler_ocf_sysex_voice_timeout:                SUBROUTINE
; Test whether the active sensing timeout is active. If not, exit.
    TST     midi_sysex_voice_timeout_active
    BEQ     .exit

; Test whether the synth is currently receiving SysEx data. If so, exit.
    TST     midi_sysex_receive_data_active
    BNE     .exit

; If incrementing the active sensing timeout counter causes it to overflow,
; reset the active sensing flags, and all the synth's voice data.
    INC     midi_active_sensing_rx_counter
    LDAA    #254
    CMPA    <midi_active_sensing_rx_counter
    BCC     .exit

    CLRA
    STAA    <midi_sysex_voice_timeout_active
    STAA    <midi_active_sensing_rx_counter
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count

.exit:
    RTS


; =============================================================================
; MIDI_REENABLE_TIMER_INTERRUPT
; =============================================================================
; LOCATION: 0xD8CC
;
; DESCRIPTION:
; Resets the CPU's internal timers.
; This is called after finishing recieving SysEx data.
;
; =============================================================================
midi_reenable_timer_interrupt:                  SUBROUTINE
    LDX     #0
    STX     <free_running_counter

; Reading this register clears the Timer Overflow Flag (TOF).
    LDAA    <timer_ctrl_status
    LDX     #2500
    STX     <output_compare

; Enable output compare (OCF) interrupt.
    LDAA    #%1000
    STAA    <timer_ctrl_status

    RTS


; =============================================================================
; MAIN_UPDATE_PEDAL_INPUT
; =============================================================================
; LOCATION: 0xD8DD
;
; DESCRIPTION:
; Updates the status of the peripheral sustain, and portamento pedals.
; Indicating whether either of them changed status, i.e being triggered on,
; or off.
;
; RETURNS:
; * ACCB: An integer indicating the status of the peripherals.
;         0 = No pedals active.
;         1 = Sustain active.
;         2 = Portamento active.
;
; =============================================================================
pedals_update:                                  SUBROUTINE
    LDAB    <io_port_1_data
    ANDB    #%11110000
    ORAB    #KEY_SWITCH_SCAN_DRIVER_SOURCE_PEDALS

; Update the peripheral scan driver source, delay, and then read the input.
    STAB    <io_port_1_data
    DELAY_SINGLE
    LDAA    <key_switch_scan_driver_input
    ANDA    #%11000000

; Store the updated pedal state in ACCB.
    TAB

; Test whether the pedal input has changed since the last time it was read.
    EORA    <pedal_status_previous
; If the result of the XOR is zero, nothing has changed. In this case
; exit returning zero.
    BEQ     .exit_input_unchanged

; If bit 7 of the result is not set, it indicates that the sustain input
; status has not changed since the previous read.
    BPL     .portamento_pedal_updated

; If this point has been reached it means that the sustain pedal input has
; been changed.
; Use XOR to update the PREVIOUS pedal state to match the NEW updated
; sustain pedal state.
    EIMD    #PEDAL_INPUT_SUSTAIN, pedal_status_previous

; Load the CURRENT state, mask the portamento, and sustain status bits,
; then add the UPDATED state byte to update the current state.
    LDAA    <pedal_status_current
    ANDA    #PEDAL_INPUT_PORTA
    ANDB    #PEDAL_INPUT_SUSTAIN
    ABA
    STAA    <pedal_status_current

; Set up the result.
    LDAB    #1
    RTS

.portamento_pedal_updated:
; Use XOR to update the PREVIOUS pedal state to match the NEW updated
; portamento pedal state.
    EIMD    #PEDAL_INPUT_PORTA, pedal_status_previous

; Load the CURRENT state, mask the portamento, and sustain status bits,
; then add the UPDATED state byte to update the current state.
    LDAA    <pedal_status_current
    ANDA    #PEDAL_INPUT_SUSTAIN
    ANDB    #PEDAL_INPUT_PORTA
    ABA
    STAA    <pedal_status_current

; Set up the result.
    LDAB    #2
    RTS

.exit_input_unchanged:
    CLRB

    RTS


; =============================================================================
; ADC_SET_SOURCE
; =============================================================================
; LOCATION: 0xD912
;
; DESCRIPTION:
; Sets the code of the next A/D input source to be read by the synth's A/D
; converter circuitry.
;
; ARGUMENTS:
; Registers:
; * ACCB: The next A/D converter source number.
;
; =============================================================================
adc_set_source:                                 SUBROUTINE
    STAB    <adc_source
    DELAY_SHORT
    STAB    <adc_source

    RTS


; =============================================================================
; ADC_UPDATE_INPUT_SOURCE
; =============================================================================
; LOCATION: 0xD919
;
; DESCRIPTION:
; This subroutine updates a particular analog input source.
; It reads an individual input source, then tests to see how much the source
; has changed since the previous read. This subroutine then test whether the
; input value has only changed by 1 'unit' in either direction, if so this
; is not considered to be a proper update, and the subroutine will return
; as the value having been unchanged.
; This code here is likely similar to the analog data conversion code contained
; in the DX7's sub-CPU mask ROM.
;
; ARGUMENTS:
; Registers:
; * ACCB: The ADC source number to update.
;
; RETURNS:
; The carry flag will be set in the event that the ADC input is unchanged.
;
; =============================================================================
adc_update_input_source:                        SUBROUTINE
; Read the analog input for the specified source.
    BSR     adc_read

; Compare the newly read analog data to the previously recorded data from
; this source.
    LDX     #analog_input_previous
    ABX
    CMPA    0,x
    BEQ     .exit_input_source_unchanged

; Increment this value to test whether it was 0xFF prior to incrementing.
; If it was, the zero flag will be set, and branching will happen.
; If the value is already at its maximum of 0xFF, don't bother testing
; whether the NEW value is 1 below the previous.
    INCA
    BEQ     .new_input_value_is_ff

; Test whether the NEW value is 1 below the OLD value.
; If so, consider it unchanged.
    CMPA    0,x
    BEQ     .exit_input_source_unchanged

.new_input_value_is_ff:
; Decrement the NEW value to return it to its original value.
; Compare against 0.
; If the NEW value is 0, don't bother checking whether it is 1 above
; the OLD value.
    DECA
    BEQ     .exit_input_source_changed

; Test whether the NEW value is 1 above the OLD value.
; If so, consider it unchanged.
    DECA
    CMPA    0,x
    BEQ     .exit_input_source_unchanged

; Increment the NEW value again to return it to its original value.
    INCA

.exit_input_source_changed:
    STAA    0,x

; Logical shift right, then arithmetic shift left.
; This clears bit 0, and the carry flag.
    LSRA
    ASLA

; Since the OLD, and NEW ADC value arrays are next to one another, this
; store instruction updates the NEW value array.
    STAA    4,x
    RTS

.exit_input_source_unchanged:
    SEC
    RTS


; =============================================================================
; ADC_READ
; =============================================================================
; LOCATION: 0xD93C
;
; DESCRIPTION:
; Reads data from the synth's analog/digital converter.
; This subroutine is part of the larger 'ADC_PROCESS' routine. The source from
; which the analog data is to be read is set in this parent subroutine.
; This subroutine will loop until the EOC pin on the ADC indicates that the
; data is ready to be read.
;
; RETURNS:
; * ACCA: The data read from the analog/digital converter.
;
; =============================================================================
adc_read:                                       SUBROUTINE
; Loop until the ADC's EOC line goes high, indicating that the analog data has
; been converted.
    TIMD    #PORT_1_ADC_EOC, io_port_1_data
    BEQ     adc_read

    LDAA    <adc_data
    RTS



; =============================================================================
; TAPE_VERIFY_PATCH
; =============================================================================
; DESCRIPTION:
; Verifies an individual incoming patch by comparing it against its associated
; index in the patch buffer.
;
; ARGUMENTS:
; Memory:
; * tape_patch_index: The patch index being verified.
;
; RETURNS:
; * The CPU flags indicate the result of the verification process.
;   The zero flag will indicate whether any byte being verified differed.
;
; =============================================================================
tape_verify_patch:                              SUBROUTINE
    LDX     #patch_buffer_tape_temp
    STX     <copy_ptr_src

; Get the offset of the original unconverted patch.
; Construct this by multiplying the incoming patch number by the patch size,
; then adding the patch buffer offset.
    LDAA    tape_patch_output_counter
    LDAB    #64
    MUL
    ADDD    #patch_buffer
    STD     <copy_ptr_dest

; Setup counter. This is 32 WORDS, since it is comparing against the DX9 format.
    LDAB    #32
    STAB    <copy_counter

.compare_word_loop:
; Load the source word.
    LDX     <copy_ptr_src
    LDD     0,x
    INX
    INX
    STX     <copy_ptr_src

; Subtract the word at the destination from the source.
; If this is different, exit.
; The CPU flags after return will indicate the result of this comparison.
    LDX     <copy_ptr_dest
    SUBD    0,x
    BNE     .exit

    INX
    INX
    STX     <copy_ptr_dest
    DEC     copy_counter
    BNE     .compare_word_loop

.exit:
    RTS


; =============================================================================
; TAPE_CALCULATE_PATCH_CHECKSUM
; =============================================================================
; DESCRIPTION:
; Calculates the checksum for an individual patch before it is output over the
; synth's cassette interface.
;
; RETURNS:
; * ACCD: The calculated checksum for the patch
;
; =============================================================================
tape_calculate_patch_checksum:                  SUBROUTINE
    LDX     #patch_buffer_tape_temp
    LDAB    #65
    STAB    <copy_counter
    CLRA
    CLRB

.calculate_checksum_loop:
    ADDB    0,x
; If the result of the previous addition to ACCB overflowed, add the carry bit
; to ACCA to expand the value into ACCD.
    ADCA    #0
    INX
    DEC     copy_counter
    BNE     .calculate_checksum_loop

    RTS


; =============================================================================
; TAPE_OUTPUT_PATCH
; =============================================================================
; DESCRIPTION:
; Outputs a single patch from the temporary tape output buffer via the synth's
; cassette interface.
;
; =============================================================================
tape_output_patch:                              SUBROUTINE
    LDX     #patch_buffer_tape_temp
    LDAB    #67
    STAB    <tape_byte_counter
    BSR     tape_output_pilot_tone
    LDAB    #28

    DELAY_SHORT
    NOP

.output_byte_loop:
    LDAA    0,x
    BSR     tape_output_byte

; @TODO: What is this?
    LDAB    #27
    DELAY_SINGLE
    INX
    DEC     tape_byte_counter
    BNE     .output_byte_loop

    RTS


; =============================================================================
; TAPE_OUTPUT_PILOT_TONE
; =============================================================================
; DESCRIPTION:
; Outputs the pilot tone played before sending a patch.
;
; ARGUMENTS:
; Memory:
; * patch_tape_counter: If this is the first patch being sent over the
;    tape interface, an extra long pilot tone is output.
;
; =============================================================================
tape_output_pilot_tone:                         SUBROUTINE
    PSHA
    PSHB
    PSHX

; If this is the first patch being output in the bulk patch dump, output
; a long pilot tone, otherwise output a short pilot tone between patches.
    TST     tape_patch_output_counter
    BNE     .output_short_pilot_tone

    LDX     #12000
    BRA     .output_pilot_tone_loop

.output_short_pilot_tone:
    LDX     #600

.output_pilot_tone_loop:
; This setting of ACCB applies to the output subroutine in the loop below.
    LDAB    #14
    DELAY_SHORT
    NOP
; Since the tape output functions add an arbitrary value to the stack
; pointer to return to the main UI functions after an error, this operation
; likely adjusts the stack pointer to match this arbitrary value.
    DES
    BSR     tape_output_bit_one
    INS
    DEX
    BNE     .output_pilot_tone_loop

    PULX
    PULB
    PULA

    RTS


; =============================================================================
; TAPE_OUTPUT_BIT_ONE
; =============================================================================
; LOCATION: 0xD9C1
;
; DESCRIPTION:
; Outputs a '1' bit via the synth's tape output interface.
; The initial pulse width is not hardcoded, since it belongs to the bit that
; was previously being output, and needs to match its length.
;
; ARGUMENTS:
; Registers:
; * ACCB: The width of the initial 'pulse'.
;
; =============================================================================
tape_output_bit_one:                            SUBROUTINE
    LDAA    #%1100000

; The setting of ACCA above sets the stating polarity of both the tape
; output, and remote ports 'high'. The 'tape_output_pulse' routine will
; use a XOR operation with the 'tape_output' port bit, keeping the remote
; port high, and inverting the output signal.
; @TODO: Why set the remote bit?
    BSR     tape_output_pulse
    BSR     tape_output_pulse_length_16
    BSR     tape_output_pulse_length_16
    BSR     tape_output_pulse_length_16
    RTS


; =============================================================================
; TAPE_OUTPUT_BIT_ZERO
; =============================================================================
; LOCATION: 0xD9CC
;
; DESCRIPTION:
; Outputs a '0' bit via the synth's tape output interface.
; The initial pulse width is not hardcoded, since it belongs to the bit that
; was previously being output, and needs to match its length.
;
; ARGUMENTS:
; Registers:
; * ACCB: The width of the initial 'pulse'.
;
; =============================================================================
tape_output_bit_zero:                           SUBROUTINE
    LDAA    #%1100000

; The setting of ACCA above sets the stating polarity of both the tape
; output, and remote ports 'high'. The 'tape_output_pulse' routine will
; use a XOR operation with the 'tape_output' port bit, keeping the remote
; port high, and inverting the output signal.
; @TODO: Why set the remote bit?
    BSR     tape_output_pulse
    LDAB    #33
    DELAY_SINGLE
    NOP
    BSR     tape_output_pulse
    RTS


; =============================================================================
; TAPE_OUTPUT_PULSE
; =============================================================================
; DESCRIPTION:
; Ouptuts a sinusoidal 'pulse' of a fixed width of 16 'cycles' to the
; synth's tape output port. This subroutine is used when outputting a '1' bit.
;
; ARGUMENTS:
; Registers:
; * ACCA: The initial polarity of the tape output port, stored in bit 6.
;         This polarity will be inverted after ACCB iterations, and sent to
;         the 'Tape Output' port.
;
; =============================================================================
tape_output_pulse_length_16:                    SUBROUTINE
    LDAB    #16
; Falls-through below.

; =============================================================================
; TAPE_OUTPUT_PULSE
; =============================================================================
; DESCRIPTION:
; Ouptuts a sinusoidal 'pulse' of a variable width to the synth's tape output
; port. This subroutine will output either a high, or a low pulse, depending
; on the input polarity.
; Two invocations of this subroutine will create a full sinusoidal period.
;
; ARGUMENTS:
; Registers:
; * ACCA: The initial polarity of the tape output port, stored in bit 6.
;         This polarity will be inverted after ACCB iterations, and sent to
;         the 'Tape Output' port.
; * ACCB: The number of 'cycles' to keep the initial tape output polarity for.
;         This is used to control the 'width' of each output pulse.
;
; =============================================================================
tape_output_pulse:                              SUBROUTINE
; Abort if the 'No' button is pressed.
    TIMD    #KEY_SWITCH_LINE_0_BUTTON_NO, key_switch_scan_driver_input
    BNE     .abort

    DECB
    BNE     tape_output_pulse

    DELAY_SHORT

; The XOR instruction here inverts the tape polarity in ACCA?
    EORA    #PORT_1_TAPE_OUTPUT
    STAA    <io_port_1_data

    RTS

.abort:
    LDAA    #1
    STAA    <tape_function_aborted_flag

; Add 11 bytes to the stack pointer to return higher up in the call chain.
    TSX
    LDAB    #11
    ABX
    TXS

    RTS


; =============================================================================
; TAPE_OUTPUT_BYTE
; =============================================================================
; DESCRIPTION:
; Outputs an individual byte over the synth's cassette interface.
;
; ARGUMENTS:
; Registers:
; * ACCA: The byte to output.
;
; =============================================================================
tape_output_byte:                               SUBROUTINE
    PSHA
    PSHB
    PSHX

; This register is used as a counter to output each bit of the byte.
    LDX     #8
    PSHA

; Send the leading zero marking the start of the data frame.
    BSR     tape_output_bit_zero
    PULA
    DELAY_SHORT
    DELAY_SHORT

.output_bit_loop:
    DELAY_SHORT

; Rotate the bit to the right, moving the LSB into the carry bit.
; If the carry bit is now set, the bit to be output is a '1'.
    RORA
    PSHA
    BCS     .output_bit_one

    LDAB    #31
    BSR     tape_output_bit_zero
    BRA     .decrement_bit_loop_counter

.output_bit_one:
    LDAB    #13
    BSR     tape_output_bit_one
    BRA     *+2

.decrement_bit_loop_counter:
    PULA
    DEX
    BNE     .output_bit_loop

; Send the tail '1's that make up the data frame end marker.
    LDAB    #$D
    DELAY_SINGLE
    NOP
    DES
    BSR     tape_output_bit_one

    LDAB    #$E
    DELAY_SINGLE
    NOP
    BSR     tape_output_bit_one
    INS

    PULX
    PULB
    PULA

    RTS


; =============================================================================
; TAPE_INPUT_PATCH
; =============================================================================
; DESCRIPTION:
; Reads an individual patch over the synth's cassette interface.
;
; =============================================================================
tape_input_patch:                               SUBROUTINE
    LDX     #patch_buffer_tape_temp
    LDAB    #67
    STAB    <tape_byte_counter
    BSR     tape_input_pilot_tone

.input_byte_loop:
    BSR     tape_input_byte
    STAA    0,x
    INX
    DEC     tape_byte_counter
    BNE     .input_byte_loop

    RTS


; =============================================================================
; TAPE_INPUT_PILOT_TONE
; =============================================================================
; DESCRIPTION:
; Reads the cassette interface 'pilot tone', played before each patch in the
; cassette storage.
;
; =============================================================================
tape_input_pilot_tone:                          SUBROUTINE
    PSHA
    PSHB
    PSHX

; Read the first tape input polarity value.
    LDAA    <io_port_1_data
    ANDA    #PORT_1_TAPE_INPUT
    STAA    <tape_input_polarity_previous

.reset_input_loop:
    CLR     tape_input_pilot_tone_counter

.read_pilot_tone_period_loop:
    CLRB
    BSR     tape_input_read_pulse
; If the pulse was '12' or more in length, reset.
    CMPB    #12
    BCC     .reset_input_loop

; If the pulse less than '4' in length, reset.
    CMPB    #4
    BCS     .reset_input_loop

    INC     tape_input_pilot_tone_counter
    BNE     .read_pilot_tone_period_loop

    PULX
    PULB
    PULA

    RTS


; =============================================================================
; TAPE_INPUT_READ_PULSE
; =============================================================================
; DESCRIPTION:
; This subroutine reads the length of a wave 'pulse' read from the cassette
; input interface.
; It polls the cassette input port, to test for the polarity changing,
; waiting until either the polarity changes, and the 'NO' button is pressed,
; which aborts the process.
;
; ARGUMENTS:
; Registers:
; * ACCB: The number of 'samples' previously read.
;
; RETURNS:
; * ACCB: The length of the pulse read so far.
;    Since the function calls itself to continue reading in the case of change
;    in polarity, this will become the new input.
;
; =============================================================================
tape_input_read_pulse:                          SUBROUTINE
; If this line goes high, indicating the 'No' button was pressed, abort.
    TIMD    #KEY_SWITCH_LINE_0_BUTTON_NO, key_switch_scan_driver_input
    BNE     .read_aborted

    INCB

; Read the tape input line on port 1.
    LDAA    <io_port_1_data
    NOP

; Mask the newly read tape input line, and XOR with the previous input to
; test whether the polarity has changed since the last read.
    ANDA    #PORT_1_TAPE_INPUT
    EORA    <tape_input_polarity_previous
; If the polarity has not changed, loop back.
    BPL     tape_input_read_pulse

; Use XOR to reset the value to what it was before the previous operation.
    EORA    <tape_input_polarity_previous
    STAA    <tape_input_polarity_previous

    RTS

.read_aborted:
; Set the tape function aborted flag.
    LDAA    #1
    STAA    <tape_function_aborted_flag

; Add '8' to the stack to exit the tape read functionality.
    TSX
    LDAB    #8
    ABX
    TXS

    RTS


; =============================================================================
; TAPE_INPUT_BYTE
; =============================================================================
; DESCRIPTION:
; Reads in a single byte from the synth's cassette interface.
;
; RETURNS:
; * ACCA: The byte read from the cassette interface.
;
; =============================================================================
tape_input_byte:                                SUBROUTINE
    PSHB
    PSHX
    DES

; Wait for the previous wave pulse to finish before beginning reading a byte.
.finish_previous_pulse_loop:
    LDAA    <io_port_1_data
    NOP
    ANDA    #PORT_1_TAPE_INPUT
    STAA    <tape_input_polarity_previous
    CLRB
    BSR     tape_input_read_pulse
    CMPB    #13
    BCS     .finish_previous_pulse_loop

; The previous pulse length is stored in ACCB.
; This call delays the difference between the previous pulse length, which had
; to be '13', or higher, and '29'.
    LDAA    #29
    STAA    <tape_input_delay_length
    BSR     tape_input_delay

    LDX     #8
.read_bit_loop:
    BSR     tape_input_read_pulse

    LDAA    #21
    STAA    <tape_input_delay_length
    CLRB
    BSR     tape_input_delay

; ACCB is incremented here in the read pulse call.
    BSR     tape_input_read_pulse

; Compare against '23', and transfer the CPU condition codes into ACCA.
; This has the effect of setting the LSB if the pulse length was over '23'
    CMPB    #23
    TPA

; XOR the carry-bit contents with '1'. This has the effect of setting the carry
; bit to '1' if the pulse length was under '23'.
    EORA    #1
    TAP

; The carry bit will be rotated into the MSB of the result byte.
    LDAA    <tape_input_read_byte
    RORA
    STAA    <tape_input_read_byte

    BSR     tape_input_read_bit_delay

    DEX
    BNE     .read_bit_loop

    LDAA    <tape_input_read_byte
    INS
    PULX
    PULB

    RTS


; =============================================================================
; TAPE_INPUT_READ_BIT_DELAY
; =============================================================================
; DESCRIPTION:
; Creates a short delay used between reading the pulses of individual bits
; when reading a byte.
;
; =============================================================================
tape_input_read_bit_delay:                      SUBROUTINE
    LDAA    #29
    STAA    <tape_input_delay_length
; Falls-through below.

; =============================================================================
; TAPE_INPUT_DELAY
; =============================================================================
; LOCATION: 0xDABC
;
; DESCRIPTION:
; Triggers a delay for an aribtrary specified period.
; This is used in the tape input subroutines.
;
; ARGUMENTS:
; Memory:
; * tape_input_delay_length: The amount of arbitrary 'cycles' to delay for.
;
; =============================================================================
tape_input_delay:                               SUBROUTINE
    DELAY_SINGLE
    DELAY_SHORT
    NOP
    INCB
    CMPB    <tape_input_delay_length
    BCS     tape_input_delay

    RTS


; =============================================================================
; TAPE_REMOTE_TOGGLE_OUTPUT_POLARITY
; =============================================================================
; LOCATION: 0xDAC7
;
; DESCRIPTION:
; Toggles the polarity of the tape 'remote' output port.
;
; =============================================================================
tape_remote_toggle_output_polarity:             SUBROUTINE
    LDAA    tape_remote_output_polarity
    EORA    #1
    STAA    tape_remote_output_polarity
; Falls-through below to output signal.

; =============================================================================
; TAPE_REMOTE_OUTPUT_SIGNAL
; =============================================================================
; LOCATION: 0xDACF
;
; DESCRIPTION:
; Sets the tape 'remote' output port's polarity to either high, or low, based
; upon the remote port polarity global variable.
;
; ARGUMENTS:
; Memory:
; * tape_remote_output_polarity: The tape polarity to set.
;
; =============================================================================
tape_remote_output_signal:                      SUBROUTINE
    LDAA    tape_remote_output_polarity
    BEQ     tape_remote_output_low_signal

    BRA     tape_remote_output_high_signal


; =============================================================================
; TAPE_REMOTE_OUTPUT_HIGH
; =============================================================================
; LOCATION: 0xDAD6
;
; DESCRIPTION:
; Sets the tape 'remote' output port's polarity to 'HIGH'.
;
; =============================================================================
tape_remote_output_high:                        SUBROUTINE
    LDAA    #1
    STAA    tape_remote_output_polarity

tape_remote_output_high_signal:
    OIMD    #PORT_1_TAPE_REMOTE, io_port_1_data
    RTS


; =============================================================================
; TAPE_REMOTE_OUTPUT_LOW
; =============================================================================
; LOCATION: 0xDADF
;
; DESCRIPTION:
; Sets the tape 'remote' output port's polarity to 'LOW'.
;
; =============================================================================
tape_remote_output_low:                         SUBROUTINE
    CLRA
    STAA    tape_remote_output_polarity

tape_remote_output_low_signal:
    AIMD    #~PORT_1_TAPE_REMOTE, io_port_1_data
    RTS


; =============================================================================
; HANDLER_RESET_INIT_PERIPHERALS
; =============================================================================
; LOCATION: 0xDAE7
;
; DESCRIPTION:
; Initialises the peripheral devices attached to the synth's CPU. This
; includes the LCD.
;
; =============================================================================
handler_reset_init_peripherals:                 SUBROUTINE
; The HD44780 datasheet instructs the user to wait for more than 15 ms after
; VCC rises to 4.5V before sending the first command.
; Call the function set command to initialise the controller settings.
    LDAA    #(LCD_FUNCTION_SET | LCD_FUNCTION_DATA_LENGTH | LCD_FUNCTION_LINES)

; Delay by decrementing IX so it wraps around, then decrement until zero.
    LDX     #0

.lcd_init_delay_1:
    DEX
    BNE     .lcd_init_delay_1

    STAA    <lcd_ctrl

.lcd_init_delay_2:
    DEX
    BNE     .lcd_init_delay_2

    STAA    <lcd_ctrl

.lcd_init_delay_3:
    DEX
    BNE     .lcd_init_delay_3

; Keep sending the initialisation command.
    STAA    <lcd_ctrl
    JSR     lcd_wait_for_ready

; Now the full function set can be sent.
; In this case, it happens to be identical.
    STAA    <lcd_ctrl
    JSR     lcd_wait_for_ready

; Turn the display on.
    LDAA    #(LCD_DISPLAY_CONTROL | LCD_DISPLAY_ON)
    STAA    <lcd_ctrl
    JSR     lcd_wait_for_ready

; Clear the LCD.
    LDAA    #LCD_CLEAR
    STAA    <lcd_ctrl
    JSR     lcd_wait_for_ready

; Set the LCD direction to 'increment'.
    LDAA    #(LCD_ENTRY_MODE_SET | LCD_ENTRY_MODE_INCREMENT)
    STAA    <lcd_ctrl

; Clear the synth's LCD 'current contents' buffer by filling each position
; in the buffer with an ASCII space.
; This buffer is used to store the current contents of the LCD screen.
    LDAA    #'
    LDX     #lcd_buffer_current

.clear_current_lcd_contents_loop:
    STAA    0,x
    INX
    CPX     #lcd_buffer_next
    BNE     .clear_current_lcd_contents_loop

; Initialise the peripheral status array.
    LDX     #key_switch_scan_input

.initialise_peripheral_status_array:
    CLR     0,x
    INX
    CPX     #pedal_status_current
    BNE     .initialise_peripheral_status_array

; Print the synth's Welcome Message to the LCD.
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_dest
    LDX     #str_welcome_message
    JSR     lcd_strcpy
    JSR     lcd_update

; Delay after printing the welcome message, then clear the LCD.
    LDX     #$FFFF

.print_welcome_message_delay:
    JSR     delay
    DEX
    BNE     .print_welcome_message_delay

    JSR     lcd_clear

    RTS


; =============================================================================
; HANDLER_RESET_SYSTEM_INIT
; =============================================================================
; LOCATION: 0xDB48
;
; DESCRIPTION:
; Handles the initialisation of the main system, and user-interface variables.
; Additionally, this subroutine will print the 'CHANGE BATTERY !' error
; message if the previously read voltage is too low.
;
; =============================================================================
handler_reset_system_init:                      SUBROUTINE
    CLR     key_tranpose_set_mode_active

; Sets the internal patch memory in a protected state.
    LDAA    #1
    STAA    memory_protect

; Clear the UI selected operator variable.
    LDAA    #$FF
    STAA    operator_selected_dest

; Reset the memory protection flags stored in the UI state variable.
    LDAA    ui_mode_memory_protect_state
    ANDA    #%11
    STAA    ui_mode_memory_protect_state

; Store a patch event flag that will force the reloading of all patch data
; to the EGS chip. This is necessary here since no data is currently loaded.
    LDAA    #EVENT_HALT_VOICES_RELOAD_PATCH
    STAA    main_patch_event_flag
    CLR     sys_info_avail

; Clear these 'alternate button function' variables.
; These are used to track the function of individual 'multi-function'
; buttons that change UI function over sequential presses.
; This clears the selected UI function, since this is in non-volatile RAM.
    CLR     ui_btn_function_6_sub_function
    CLR     ui_btn_function_7_sub_function
    CLR     ui_btn_function_19_sub_function

; If the synth has been reset after the diagnostic test routines have
; been performed, reload the currently selected patch.
    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_TEST_ENTRY_COMBO
    BNE     .test_battery_voltage

    JSR     ui_test_entry_reload_patch_and_exit

.test_battery_voltage:
; Test the battery voltage.
; If this is too low, print the 'CHANGE BATTERY !' message.
    LDAA    analog_input_battery_voltage
    CMPA    #110
    BCC     .battery_voltage_ok

    LDX     #str_change_battery
    JSR     lcd_strcpy
    JSR     lcd_update
    BRA     .exit

.battery_voltage_ok:
    JSR     ui_print_update_led_and_menu

.exit:
    RTS

str_welcome_message:                    DC "*  YAMAHA DX9  **  SYNTHESIZER *", 0
str_change_battery:                     DC "CHANGE BATTERY !", 0


input_read_front_panel_numeric_switches_jumpoff:
; The following 'jumpoff' table is used to alter the result of
; the value read from the front-panel numeric switches.
; Don't bother trying to understand the logic here. It simply transforms
; one value to another in a convenient, arbitrary way.
    JSR     jumpoff

    DC.B input_read_front_panel_numeric_switches_exit - *
    DC.B 4
    DC.B input_read_front_panel_exit_add_1 - *
    DC.B 5
    DC.B input_read_front_panel_numeric_switches_exit - *
    DC.B 9
    DC.B input_read_front_panel_numeric_switches_exit_subtract_1 - *
    DC.B 25
    DC.B input_read_front_panel_exit - *
    DC.B 26
    DC.B input_read_front_panel_numeric_switches_exit_subtract_2 - *
    DC.B 30
    DC.B input_read_front_panel_exit - *
    DC.B 0

input_read_front_panel_numeric_switches_exit_subtract_2:
    DECB

input_read_front_panel_numeric_switches_exit_subtract_1:
    DECB

input_read_front_panel_numeric_switches_exit:
    RTS


; =============================================================================
; INPUT_READ_FRONT_PANEL
; =============================================================================
; LOCATION: 0xDBD4
;
; DESCRIPTION:
; This subroutine reads the key/switch scan driver to get the state of the
; synth's front-panel swith input.
; This routine will return a value suitable for reading in the UI functions.
;
; Input line 0 covers the 'main' front-panel switches.
; Input line 1 covers the numeric front-panel switches 1 through 8.
; Input line 2 covers the numeric front-panel switches 9 though 16.
; Input line 3 covers the numeric front-panel switches 17 though 20, as well
; as the modulation pedal inputs: The Portamento, and Sustain pedals are
; mapped to bits 6, and 7 respectively.
;
; RETURNS:
; * ACCB: A numeric code indicating the last input source received.
;         0:    Slider
;         1:    "YES/INCREMENT"
;         2:    "NO/DECREMENT"
;         3:    "STORE"
;         4:    -Button Released-
;         5:    "FUNCTION"
;         6:    "EDIT"
;         7:    "MEMORY"
;         8-27: Buttons 1-20
;
; =============================================================================
input_read_front_panel:                         SUBROUTINE
    LDX     #key_switch_scan_input

; Set the key/switch scan input driver source to its initial value of 0.
    LDAB    <io_port_1_data
    ANDB    #%11110000

.test_key_switch_input_source_loop:
    STAB    <io_port_1_data
    DELAY_SINGLE

; Read the new data for the selected source, and test whether the data has
; changed since the last read.
    LDAA    <key_switch_scan_driver_input
    CMPA    0,x

; Function returns from this call.
    BNE     input_read_front_panel_source_updated

    INX
    INCB

; If the input source is less than 4, loop.
    BITB    #%100
    BEQ     .test_key_switch_input_source_loop

input_read_front_panel_exit:
    CLRB
    RTS


; =============================================================================
; INPUT_READ_FRONT_PANEL_SOURCE_UPDATED
; =============================================================================
; DESCRIPTION:
; Handles the situation where a particular key/switch interface input line has
; been updated. This subroutine is responsible for creating the final result
; value corresponding to the input line.
;
; ARGUMENTS:
; Registers:
; * ACCA: The updated input value.
; * ACCB: The selected input line (non-masked).
; * IX:   A pointer to the previous input line value.
;
; RETURNS:
; * ACCB: The 'source' of the numeric button that is updated.
;         Refer to the documentation for the 'input_read_front_panel'
;         subroutine above.
;
; =============================================================================
input_read_front_panel_source_updated:          SUBROUTINE
; Mask the peripheral source.
; Only input sources 0-3 are updated in this routine.
    ANDB    #%11

; If source is input line 1/2/3...
    BNE     input_read_front_panel_numeric_switches

; If source is input line 0.
    PSHA

; Test whether input line 0, bit 4 has changed.
; Branch if a button other than 'Store' was pushed.
    EORA    0,x
    ANDA    #%100
    PULA
    BEQ     input_read_front_panel_numeric_switches

; If the 'Store' button has changed.
; Store the updated value.
    STAA    0,x

; Check whether the store button is active.
; If so, return '3', else return the default of '4'.
    LDAB    #3
    BITA    #%100
    BNE     .exit_store_button_active

input_read_front_panel_exit_add_1:
    INCB

.exit_store_button_active:
    RTS


; =============================================================================
; INPUT_READ_FRONT_PANEL_NUMERIC_SWITCHES
; =============================================================================
; DESCRIPTION:
; Scans a particular input line to update the numeric front-panel switches.
;
; ARGUMENTS:
; Registers:
; * ACCA: The updated input value.
; * ACCB: The selected input line.
; * IX:   A pointer to the previous input line value.
;
; RETURNS:
; * ACCB: The 'source' of the numeric button that is updated.
;         Refer to the documentation for the 'input_read_front_panel'
;         subroutine above.
;
; =============================================================================
input_read_front_panel_numeric_switches:        SUBROUTINE
; Shift the source left 3 times to create an offset so that the buttons can be
; grouped sequentially in groups of 8.
; i.e: Front-panel button 1 has value '8', and is read by input source 1.
; i.e: Front-panel button 20 has value '27', and is read by input source 3.
    ASLB
    ASLB
    ASLB
    PSHB

; Load previous value...
    LDAB    0,x

; Store updated value.
    STAA    0,x

; If the inverted old value, AND the new value is not equal to 0, it shows this
; switch has transitioned from OFF to ON.
    COMB
    ANDB    0,x
    BEQ     .exit_switch_transitioned_off

; Handle the switch state transitioning to ON.
    TBA
    EORB    0,x
    STAB    0,x

; The following section performs the arithmetic necessary to transform the
; button input codes into sequential values.
; It's not particularly necessary to understand the logic here. The aim of this
; code is simply to transform the result read from the key/switch scan driver
; into the appropriate button code for the firmware.
    CLR     updated_input_source

.convert_source_to_offset_loop:
    INC     updated_input_source
    LSRA
    BCC     .convert_source_to_offset_loop

    PULB
    ADDB    <updated_input_source
    CLRA

; Recreate the input line bitmask, and store it.
    SEC
.create_bitmask_loop:
    ROLA
    DEC     updated_input_source
    BNE     .create_bitmask_loop

    ORAA    0,x
    STAA    0,x
    BRA     input_read_front_panel_numeric_switches_jumpoff

.exit_switch_transitioned_off:
; If the switch is transitioning to an 'Off' state, increment the stack, and
; return to go back to the main loop.
    INS
    CLRB
    RTS


; =============================================================================
; JUMPOFF
; =============================================================================
; LOCATION: 0xDC32
;
; DESCRIPTION:
; This subroutine pops a reference to a jump-table from the subroutine's
; return pointer on the stack, then unconditionally 'jumps' to the relative
; offset in the entry associated with the number in ACCB.
; The table is stored in a two-byte format (Entry Number):(Relative Offset).
; Once the correct entry in the table has been found, the relative offset is
; added to the pointer in IX, and then jumped to.
; This is effectively a switch statement, with a relative jump.
;
; ARGUMENTS:
; Registers:
; * IX:   The 'return address' is popped off the stack into IX.
; * ACCB: The 'number' of the entry to jump to.
;
; =============================================================================
jumpoff:                                        SUBROUTINE
    PULX

.test_table_entry_offset:
; If the current jump table entry number is '0', the end of the jump table has
; been reached, so exit.
    TST     1,x
    BEQ     .load_offset_and_jump

; If the value in the entry 'index' is higher than the value in ACCB being
; tested, jump to the relative offset contained in this entry.
    CMPB    1,x
    BCS     .load_offset_and_jump
    INX
    INX
    BRA     .test_table_entry_offset

.load_offset_and_jump:
; Load the relative offset in the current entry, add this to the return
; address popped from the stack, and jump to it.
    PSHB
    LDAB    0,x
    ABX
    PULB
    JMP     0,x


; =============================================================================
; JUMPOFF_INDEXED_FROM_ACCA
; =============================================================================
; LOCATION: 0xDC46
;
; DESCRIPTION:
; Jumps to a relative function offset loaded from a relative offset
; supplied in the ACCA register argument.
; The functionality is the same as the 'JUMPOFF_INDEXED' subroutine, except
; with the relative offset provided in the ACCA register.
;
; ARGUMENTS:
; Registers:
; * ACCA: The relative offset of the function offset from the calling
;         function's return address.
;
; =============================================================================
jumpoff_indexed_from_acca:                      SUBROUTINE
    PULX
    PSHB
    TAB
    BRA     jumpoff_indexed_from_accb


; =============================================================================
; JUMPOFF_INDEXED
; =============================================================================
; LOCATION: 0xDC4B
;
; DESCRIPTION:
; Jumps to a relative function offset loaded from a relative offset
; supplied in the ACCB register argument.
; The return address of this subroutine is popped off the stack, and the
; relative offset provided is added to this address. From this address, the
; SECond relative offset is loaded, which is added to the previous address.
; This pointer is then jumped to.
;
; ARGUMENTS:
; Registers:
; * ACCB: The relative offset of the function offset from the calling
;         function's return address.
;
; =============================================================================
jumpoff_indexed:                                SUBROUTINE
    PULX
    PSHB

jumpoff_indexed_from_accb:
; TOTAL CPU CYCLES: 12
    ABX
    LDAB    0,x
    ABX
    PULB
    JMP     0,x


; =============================================================================
; MEMCPY_STORE_DEST_AND_COPY_ACCB_BYTES
; =============================================================================
; LOCATION: 0xDC54
;
; DESCRIPTION:
; Thunk routine for 'memcpy', which stores the destination pointer, and then
; falls through to copy ACCB bytes.
; Refer to the documentation for 'memcpy'.
;
; ARGUMENTS:
; Registers:
; * IX:   The destination memory address.
; * ACCB: The number of bytes to copy.
;
; Memory:
; * memcpy_ptr_src: The source memory address.
;
; =============================================================================
memcpy_store_dest_and_copy_accb_bytes:          SUBROUTINE
    STX     <memcpy_ptr_dest
; Falls-through below.

; =============================================================================
; MEMCPY
; =============================================================================
; LOCATION: 0xDC56
;
; DESCRIPTION:
; Copies ACCB bytes from the address in the source pointer, to the address in
; the destination pointer.
; The source, and destination pointers in 0xCE, and 0xD0 respectively are
; incremented with each iteration.
;
; ARGUMENTS:
; Registers:
; * ACCB: The number of bytes to copy.
;
; Memory:
; * memcpy_ptr_src:  The source memory address.
; * memcpy_ptr_dest: The destination memory address.
;
; =============================================================================
memcpy:                                         SUBROUTINE
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src

    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest

    DECB
    BNE     memcpy

    RTS


; =============================================================================
; PATCH_SERIALISE
; =============================================================================
; LOCATION: 0xDC68
;
; DESCRIPTION:
; Serialises a patch from the 'unpacked' edit buffer format to the 64 byte
; 'packed' format in the synth's internal memory.
;
; ARGUMENTS:
; Memory:
; * memcpy_ptr_src:  The source patch buffer pointer.
; * memcpy_ptr_dest: The destination patch buffer pointer.
;
; =============================================================================
patch_serialise:                                SUBROUTINE
    LDAB    #4

.serialise_operator_loop:
; Copy the first 9 bytes.
    PSHB
    LDAB    #9
    BSR     memcpy_store_dest_and_copy_accb_bytes

; Load the operator keyboard scaling rate, and mask the valid bits.
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    ANDA    #%111

; Load the operator amp mod sensitivity, and mask the valid bits.
    LDAB    0,x
    INX
    STX     <memcpy_ptr_src
    ANDB    #%11

; Combine the two values together and store.
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    0,x

; Copy the last 4 bytes of the operator data.
    INX
    LDAB    #4
    BSR     memcpy_store_dest_and_copy_accb_bytes
    PULB
    DECB
    BNE     .serialise_operator_loop

; Copy the algorithm.
    LDAB    #1
    BSR     memcpy_store_dest_and_copy_accb_bytes

; Load feedback into ACCA.
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    ANDA    #%111
; Load oscillator sync into ACCB.
    LDAB    0,x
    INX
    STX     <memcpy_ptr_src
    ANDB    #1
; Combine these two values, and store.
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX

; Copy the next 4 bytes.
    LDAB    #4
    BSR     memcpy_store_dest_and_copy_accb_bytes
; Load LFO pitch mod sens?
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    ANDA    #%111
; Load LFO wave?
    LDAB    0,x
    INX
    STX     <memcpy_ptr_src
    ANDB    #%111
; Combine these two values, and store.
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
; Copy key transpose, and return.
    LDAB    #1
    BRA     memcpy_store_dest_and_copy_accb_bytes


; =============================================================================
; PATCH_DESERIALISE
; =============================================================================
; LOCATION: 0xDCC8
;
; DESCRIPTION:
; Deserialises a patch from the 'packed' format used to store patches in the
; synth's internal to the 'unpacked' format in the synth's edit buffer.
;
; ARGUMENTS:
; Memory:
; * memcpy_ptr_src:  The source patch buffer pointer.
; * memcpy_ptr_dest: The destination patch buffer pointer.
;
; =============================================================================
patch_deserialise:                              SUBROUTINE
    LDAB    #4

.deserialise_operator_loop:
; Copy the first 9 bytes.
    PSHB
    LDAB    #9
    BSR     memcpy_store_dest_and_copy_accb_bytes

; Load the combined operator keyboard scaling rate, and amp mod sensitivity.
    LDX     <memcpy_ptr_src
    LDAA    0,x
    ANDA    #%111
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src
    LSRA
    LSRA
    LSRA
    ANDA    #%11
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX

; Copy the last 4 bytes of operator data.
    LDAB    #4
    JSR     memcpy_store_dest_and_copy_accb_bytes
    PULB
    DECB
    BNE     .deserialise_operator_loop

; Copy the algorithm.
    LDAB    #1
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src

; Load the combined feedback and oscillator sync values.
    LDAA    0,x
    ANDA    #%111
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src
    LSRA
    LSRA
    LSRA
    ANDA    #1
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX

; Copy the next 4 bytes.
    LDAB    #4
    JSR     memcpy_store_dest_and_copy_accb_bytes

; Load the combined LFO pitch mod sens, and LFO wave values.
    LDX     <memcpy_ptr_src
    LDAA    0,x
    ANDA    #%111
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src
    LSRA
    LSRA
    LSRA
    ANDA    #7
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
; Copy key transpose, and return.
    LDAB    #1
    JMP     memcpy_store_dest_and_copy_accb_bytes


; =============================================================================
; PATCH_VALIDATE_FIX_MAX_VALUES
; =============================================================================
; LOCATION: 0xDD41
;
; DESCRIPTION:
; This subroutine loops over a section of patch data, ensuring that all values
; are under their maximum values.
;
; ARGUMENTS:
; Registers:
; * ACCB: The number of bytes to validate.
;
; Memory:
; * memcpy_ptr_src: A pointer to the patch data to compare against the table of
;    maximum values.
; * memcpy_ptr_dest: A pointer to the table of maximum values.
;
; =============================================================================
patch_validate_fix_max_values:                  SUBROUTINE
    LDX     <memcpy_ptr_dest
    LDAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src

; Test whether the patch data byte exceeds the maximum value.
; If so, set it to the maximum value. If not, branch.
    CMPA    0,x
    BCC     .increment_pointer

    STAA    0,x

.increment_pointer:
    INX
    STX     <memcpy_ptr_src
    DECB
    BNE     patch_validate_fix_max_values

    RTS


; =============================================================================
; PATCH_VALIDATE
; =============================================================================
; LOCATION: 0xDD57
;
; DESCRIPTION:
; Validates the patch data currently loaded into the synth's 'Edit Buffer'.
; This subroutine iterates over all of the patch data, comparing it to a
; table of valid maximum values. If the value being compared exceeds the
; maximum value, it will be set to the maximum.
;
; =============================================================================
patch_validate:                                 SUBROUTINE
    LDAB    #4
    LDX     #patch_buffer_edit
    STX     <memcpy_ptr_src

.validate_operator_loop:
; Validate an individual operator.
; Reloads the table of maximum values with each iteration to start loading
; the maximum values from the start of the table.
    LDX     #table_max_patch_values
    STX     <memcpy_ptr_dest
    PSHB
    LDAB    #15
    BSR     patch_validate_fix_max_values
    PULB
    DECB
    BNE     .validate_operator_loop

; Validate the remaining non-operator values.
    LDAB    #10
    BRA     patch_validate_fix_max_values


; =============================================================================
; Maximum patch value table.
; This table contains the maximum values for each of the values in a patch.
; This is used for validation of incoming data.
; =============================================================================
table_max_patch_values:
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 7
    DC.B 3
    DC.B $63
    DC.B $1F
    DC.B $63
    DC.B $E
    DC.B 7
    DC.B 7
    DC.B 1
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 5
    DC.B 7
    DC.B $18


; =============================================================================
; PATCH_GET_PTR_TO_CURRENT
; =============================================================================
; LOCATION: 0xDD89
;
; DESCRIPTION:
; Gets a pointer to the currently selected patch.
;
; ARGUMENTS:
; Memory:
; * patch_index_current: The 0-indexed patch number to get the pointer to.
;    If this is a negative numnber, a pointer to the initialised patch
;    buffer will be returned.
;
; RETURNS:
; * IX: A pointer to the selected patch.
;
; =============================================================================
patch_get_ptr_to_current:                       SUBROUTINE
    LDAB    patch_index_current
    BMI     .get_pointer_to_init_buffer

    LDAA    #64
    MUL
    ADDD    #patch_buffer
    XGDX
    BRA     .exit

.get_pointer_to_init_buffer:
    LDX     #patch_buffer_init_voice

.exit:
    RTS


; =============================================================================
; PATCH_OPERATOR_GET_PTR_TO_SELECTED
; =============================================================================
; LOCATION: 0xDD9B
;
; DESCRIPTION:
; Gets a pointer to the selected operator's data in the patch edit buffer.
;
; ARGUMENTS:
; Memory:
; * operator_selected_src: The currently selected operator.
;
; RETURNS:
; * IX: A pointer to the selected operator.
;
; =============================================================================
patch_operator_get_ptr_to_selected:             SUBROUTINE
    LDAB    operator_selected_src
; Falls-through below.

; =============================================================================
; PATCH_OPERATOR_GET_PTR
; =============================================================================
; LOCATION: 0xDD9E
;
; DESCRIPTION:
; Gets a pointer to the specified operator's data in the patch edit buffer.
;
; ARGUMENTS:
; Registers:
; * ACCB: The operator number (from 0-3) to get a pointer to.
;
; RETURNS:
; * IX: A pointer to the selected operator.
;
; =============================================================================
patch_operator_get_ptr:                         SUBROUTINE
; 'Reverse' the operator numbering from 0-3 to 3-0, since the ordering in the
; edit buffer is in reverse.
    COMB
    ANDB    #3

    LDAA    #15
    MUL
    ADDD    #patch_buffer_edit
    XGDX

    RTS


; =============================================================================
; LCD_PRINT_NUMBER_THREE_DIGITS
; =============================================================================
; LOCATION: 0xDDA9
;
; DESCRIPTION:
; Prints a number with three digits to a string buffer.
; This subroutine will print the most-significant digit, and automatically
; fall through to print the remaining digits.
;
; ARGUMENTS:
; Registers:
; * ACCA: The number to be printed.
;
; Memory:
; * memcpy_ptr_dest: The destination string buffer pointer, pointing to where
;    the resulting number will be printed to.

; =============================================================================
lcd_print_number_three_digits:                  SUBROUTINE
    CLR     lcd_print_number_print_zero_flag
    LDAB    #100
    BSR     lcd_print_number_get_digit
; Falls-through below.

; =============================================================================
; LCD_PRINT_NUMBER_TWO_DIGITS
; =============================================================================
; LOCATION: 0xDDB0
;
; DESCRIPTION:
; Prints a number with two digits to a string buffer.
; This subroutine will print the most-significant digit, and automatically
; fall through to print the remaining digits.
;
; ARGUMENTS:
; Registers:
; * ACCA: The number to be printed.
;
; Memory:
; * memcpy_ptr_dest: The destination string buffer pointer, pointing to where
;    the resulting number will be printed to.
;
; =============================================================================
lcd_print_number_two_digits:                    SUBROUTINE
    STAB    <lcd_print_number_print_zero_flag
    LDAB    #10
    BSR     lcd_print_number_get_digit
; Falls-through below.

; =============================================================================
; LCD_PRINT_NUMBER_SINGLE_DIGIT
; =============================================================================
; LOCATION: 0xDDB6
;
; DESCRIPTION:
; Prints a single digit number to a string buffer.
;
; ARGUMENTS:
; Registers:
; * ACCA: The number to be printed.
;
; Memory:
; * memcpy_ptr_dest: The destination string buffer pointer, pointing to where
;    the resulting number will be printed to.
;
; =============================================================================
lcd_print_number_single_digit:                  SUBROUTINE
    ADDA    #'0
    TAB
    BRA     lcd_print_number


; =============================================================================
; LCD_PRINT_NUMBER_GET_DIGIT
; =============================================================================
; LOCATION: 0xDDBB
;
; DESCRIPTION:
; This subroutine converts one digit of a number to its ASCII equivalent.
; This is used as part of the 'lcd_print_number' routines.
; The 'divisor' argument passed in ACCB is used to determine which digit of a
; multipl digit number is returned.
;
; ARGUMENTS:
; Registers:
; * ACCA: The number to get the digit(s) of.
; * ACCB: The divisor for the operation.
;         This is used to find the ASCII digit by determining how
;         many of the divisor fit into the required number.
;         e.g: For getting the first digit of a three digit number, the
;         divisor should be '100'.
;
; RETURNS:
; * ACCA: The remainder after getting the current digit.
;         e.g: If the digit was the SECond digit of '123', the remainder
;         returned from the function will be '3'.
; * ACCB: The ASCII digit result, with 0x20 subtracted.
;         This is used to indicate whether a digit above zero was found.
;         This is used to determine whether a zero should be printed if the
;         function is called as part of printing a multiple digit number.
;         This will be saved, and passed to the next invocation.
;
; =============================================================================
lcd_print_number_get_digit:                     SUBROUTINE
    STAB    <lcd_print_number_divisor

; Begin with an ASCII zero as the result byte.
    LDAB    #'0

; Is the number in ACCA less than the divisor?
; This tests whether the remaining number is divisible by the divisor.
.is_number_divisable:
    CMPA    <lcd_print_number_divisor
    BCS     .is_number_zero

; If the number is more than the divisor, increment the result, and subtract
; the divisor.
    INCB
    SUBA    <lcd_print_number_divisor
    BRA     .is_number_divisable

.is_number_zero:
; Test whether the resulting digit is equal to ASCII zero.
    CMPB    #'0
    BNE     lcd_print_number

; If the result is an ASCII zero, test whether the zero should be printed,
; or whether it should print an ASCII space.
    TST     lcd_print_number_print_zero_flag
    BNE     lcd_print_number

    LDAB    #'

lcd_print_number:
    BSR     lcd_store_character_and_increment_ptr
    SUBB    #'
    RTS


; =============================================================================
; LCD_STRCPY
; =============================================================================
; LOCATION: 0xDDD8
;
; DESCRIPTION:
; Prints either a null-terminated string, or string sequence to a destination
; string buffer.
; The DX9 firmware supports the idea of a 'String Sequence', consisting of a
; series off offsets from an arbitrary location stored with the string. If
; these are encountered, a new string will be recursively loaded from this
; relative position, and printed until a terminating null character is found.
; This supports combining a series of strings into a sequence.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the string to print.
;
; MEMORY USED:
; * memcpy_ptr_dest: The destination string buffer pointer.
;
; RETURNS:
; * IX:   A pointer to the last character written.
; * ACCB: The terminating character. This is actually used by the menu print
;         function. The parameter name strings are terminated with an integer
;         indexing the function used to print the associated parameter value.
;
; =============================================================================
lcd_strcpy:                                     SUBROUTINE
    LDAB    0,x

; Is the character under the cursor equal or higher than 0x80?
; If so, this is a relative offset into the string table.
    BMI     .print_offset_string

; Test whether the character under the cursor is above ASCII space (0x20).
; If so, copy. Otherwise exit.
    CMPB    #32
    BCC     .copy_character
    RTS

.copy_character:
    BSR     lcd_store_character_and_increment_ptr
    INX
    BRA     lcd_strcpy

.print_offset_string:
; If the byte under the cursor is above 0x80 it represents an offset from this
; fixed point in the string table. This is a pointer to another string.
; The function is called recursively with this pointer.
; Once the recursive call returns, the pointer is incremented, and execution
; returns to the start of the function.
; This allows multiple strings to be called together in a predefined sequence.
    PSHX
    LDX     #string_fragment_offset_start
    ABX
    BSR     lcd_strcpy
    PULX
    INX
    BRA     lcd_strcpy


; =============================================================================
; LCD_STORE_CHARACTER_AND_INCREMENT_PTR
; =============================================================================
; LOCATION: 0xDDF1
;
; DESCRIPTION:
; Copies an individual character to the address stored in the memcpy
; destination pointer, then increments and stores the pointer. This routine is
; used by the string copy functions.
;
; ARGUMENTS:
; Registers:
; * ACCB: The character to store in the string buffer.
;
; Memory:
; * memcpy_ptr_dest: The destination string buffer pointer.
;
; RETURNS:
; * IX:   A pointer to the newly updated copy destination.
;
; =============================================================================
lcd_store_character_and_increment_ptr:          SUBROUTINE
    PSHX
    LDX     <memcpy_ptr_dest
    STAB    0,x
    INX
    STX     <memcpy_ptr_dest
    PULX

    RTS


; =============================================================================
; LCD_WAIT_FOR_READY
; =============================================================================
; LOCATION: 0xDDFB
;
; DESCRIPTION:
; Polls the LCD controller until it returns a status indicating that it is
; ready to accept new data.
;
; =============================================================================
lcd_wait_for_ready:                             SUBROUTINE
    TST     lcd_ctrl
    BMI     lcd_wait_for_ready

    RTS


; =============================================================================
; LCD_UPDATE
; =============================================================================
; LOCATION: 0xDE01
;
; DESCRIPTION:
; Updates the LCD screen with the contents of the LCD 'Next Contents' buffer.
; This compares the next contents against the current contents to determine
; whether any copy needs to take place. If so, the current content buffer will
; be updated also.
;
; =============================================================================
lcd_update:                                     SUBROUTINE
; Load the address of the LCD's 'next', and 'current' contents buffers into
; the copy source, and destination pointers.
; Each character being copied is compared against the current LCD contents to
; determine whether it needs to be copied. Identical characters are skipped.
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_src
    LDX     #lcd_buffer_current
    STX     <memcpy_ptr_dest

; Load instruction to set LCD cursor position into B.
; This is incremented with each character copy operation, so that the position
; the command sets the cursor to stays correct.
    LDAB    #LCD_SET_POSITION

.lcd_update_copy_loop:
; Load ACCA from address pointer.
    LDX     <memcpy_ptr_src
    LDAA    0,x
; Increment the source pointer.
    INX
    STX     <memcpy_ptr_src

; If the next char to be printed matches the one in the same position
; in the LCD's current contents, it can be skipped.
    LDX     <memcpy_ptr_dest
    CMPA    0,x
    BEQ     .lcd_update_copy_loop_advance

; Write the instruction to update the LCD cursor position.
    BSR     lcd_wait_for_ready
    STAB    <lcd_ctrl

; Write the character data.
    BSR     lcd_wait_for_ready
    STAA    <lcd_data

; Store the character in the current LCD contents buffer.
    STAA    0,x

.lcd_update_copy_loop_advance:
; Increment the copy destination pointer.
    INX
    STX     <memcpy_ptr_dest

; Increment cursor position in ACCB, exit if we're at the end of the 2nd line.
    INCB
    CMPB    #(LCD_SET_POSITION + 0x40 + 16)
    BEQ     .lcd_update_exit

; Check whether the end of the first line has been reached.
; If so, set the current position to the start of the SECond line.
; Otherwise continue copying the first line contents.
    CMPB    #(LCD_SET_POSITION + 16)
    BNE     .lcd_update_copy_loop

; This instruction sets the LCD cursor to start of the SECond line.
    LDAB    #(LCD_SET_POSITION + 0x40)
    BRA     .lcd_update_copy_loop

.lcd_update_exit:
    RTS


; =============================================================================
; UI_BUTTON_MAIN
; =============================================================================
; LOCATION: 0xDE35
;
; DESCRIPTION:
; Main UI subroutine for the 'main', non-numeric, front-panel buttons.
; This subroutine creates an index into a jump table based upon the current
; UI input mode, and then jumps to the relevant function for button that
; was pressed, based upon the input mode.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode.
; * ACCB: 'Main' front-panel buttons indexed from 0.
;          - 0: "STORE"
;          - 1: ???
;          - 2: "FUNCTION"
;          - 3: "EDIT"
;          - 4: "MEMORY "
;
; =============================================================================
ui_button_main:                                 SUBROUTINE
; Mask these bits to ignore the memory protect flags.
    ANDA    #%11
    BEQ     .clamp_index

; @TODO: What is this UI mode?
; This does not seem to be reachable.
    CMPA    #UI_MODE_UNKNOWN
    BEQ     .clamp_index

.get_index_loop:
; Create an index into the UI main button function table based upon the
; current UI mode.
; This works by adding 5 to the button index per mode index.
    ADDB    #5
    DECA
    BNE     .get_index_loop

.clamp_index:
; Clamp the index at 14.
    CMPB    #15
    BCS     .jumpoff

    CLRB

.jumpoff:
    JSR     jumpoff_indexed

; =============================================================================
; UI Input Main Button Handlers.
; =============================================================================
    DC.B ui_button_main_exit - *
    DC.B ui_button_main_exit - *
    DC.B ui_button_main_exit - *
    DC.B ui_button_function_edit - *
    DC.B ui_button_function_play - *

; =============================================================================
; UI Input Main Button Handlers: Memory Protect Disabled.
; =============================================================================
    DC.B ui_button_edit_store - *
    DC.B ui_memory_protect_state_clear - *
    DC.B ui_button_edit_function - *
    DC.B ui_patch_compare_toggle - *
    DC.B ui_button_edit_play - *

; =============================================================================
; UI Input Main Button Handlers: Memory Protect Enabled.
; =============================================================================
    DC.B ui_memory_protect_state_set - *
    DC.B ui_memory_protect_state_clear - *
    DC.B ui_mode_function - *
    DC.B ui_mode_edit - *
    DC.B ui_button_main_exit - *

ui_button_main_exit:
    RTS


; =============================================================================
; UI_BUTTON_EDIT_STORE
; =============================================================================
; LOCATION: 0xDE5A
;
; DESCRIPTION:
; Handles the 'STORE' button being pressed while the synth's UI is in
; 'Edit Mode'. If the synth is not currently in 'Patch Compare' mode, this will
; place the synth in 'Store' mode.
;
; =============================================================================
ui_button_edit_store:
    TST     patch_compare_mode_active
    BNE     ui_memory_protect_state_set_exit

; =============================================================================
; UI_MEMORY_PROTECT_STATE_SET
; =============================================================================
; LOCATION: 0xDE5F
;
; DESCRIPTION:
; This subroutine sets the memory protect bits in the UI state register.
; These bits are set based upon the current value of the memory protection.
; If memory protect is enabled, bit 3 is set.
; If memory protect is disabled bit 2 is set.
; Setting these bits puts the UI into 'Store' mode.
;
; =============================================================================
ui_memory_protect_state_set:
    LDAA    memory_protect
    ANDA    #1
    INCA
    ASLA
    ASLA
    ORAA    ui_mode_memory_protect_state
    STAA    ui_mode_memory_protect_state

ui_memory_protect_state_set_exit:
    RTS


; =============================================================================
; UI_MEMORY_PROTECT_STATE_CLEAR
; =============================================================================
; DESCRIPTION:
; Clears the UI memory protect state.
;
; =============================================================================
ui_memory_protect_state_clear:                  SUBROUTINE
    LDAA    #%11
    ANDA    ui_mode_memory_protect_state
    STAA    ui_mode_memory_protect_state
    RTS


; =============================================================================
; UI_PATCH_COMPARE_TOGGLE
; =============================================================================
; LOCATION: 0xDE77
;
; DESCRIPTION:
; Toggles the 'Patch Compare Mode' state based upon a press of the front-panel
; 'Edit/Compare' button while the synth is in the 'Edit' UI mode.
;
; =============================================================================
ui_patch_compare_toggle:                        SUBROUTINE
    LDAA    patch_current_modified_flag
    BEQ     ui_button_main_exit

    TST     patch_compare_mode_active
    BNE     .compare_mode_active

    LDAA    #1
    STAA    patch_compare_mode_active
    JMP     patch_copy_edit_to_compare_and_load_current

.compare_mode_active:
    CLR     patch_compare_mode_active
    JSR     patch_restore_edit_buffer_from_compare

    LDAA    #BUTTON_EDIT_20
    CMPA    ui_btn_numeric_last_pressed
    BEQ     .last_button_key_tranpose

    LDX     ui_active_param_address
    BRA     .send_active_edit_parameter

.last_button_key_tranpose:
    LDX     #patch_edit_key_transpose

.send_active_edit_parameter:
    JMP     midi_sysex_tx_param_change


; =============================================================================
; UI_BUTTON_EDIT_FUNCTION
; =============================================================================
; LOCATION: 0xDEA1
;
; DESCRIPTION:
; Handles an 'Edit' keypress while the synth's UI is in 'Function' mode.
;
; =============================================================================
ui_button_edit_function:                        SUBROUTINE
    BSR     ui_button_edit_save_previous
; Falls-through below.

; =============================================================================
; UI_MODE_FUNCTION
; =============================================================================
; DESCRIPTION:
; Sets the synth's UI mode to 'Function'
;
; =============================================================================
ui_mode_function:                               SUBROUTINE
    CLR     ui_mode_memory_protect_state
    LDAB    ui_btn_numeric_previous_fn_mode
    JMP     ui_button_numeric


; =============================================================================
; UI_BUTTON_FUNCTION_EDIT
; =============================================================================
; DESCRIPTION:
; Handles a 'Function' keypress while the synth's UI is in 'Edit' mode.
;
; =============================================================================
ui_button_function_edit:                        SUBROUTINE
    BSR     ui_button_function_save_previous
; Falls-through below.

; =============================================================================
; UI_MODE_EDIT
; =============================================================================
; DESCRIPTION:
; Sets the synth's UI into 'Edit' mode.
;
; =============================================================================
ui_mode_edit:                                   SUBROUTINE
    LDAA    #UI_MODE_EDIT
    STAA    ui_mode_memory_protect_state

; @TODO: Verify why these two UI flags are necessary.
    STAA    ui_flag_blocks_key_transpose
    STAA    ui_flag_disable_edit_btn_9_mode_select
    LDAB    ui_btn_numeric_previous_edit_mode
    JMP     ui_button_numeric


; =============================================================================
; UI_BUTTON_FUNCTION_PLAY
; =============================================================================
; DESCRIPTION:
; Handles a 'Play' keypress while the UI is in 'Function' mode.
;
; =============================================================================
ui_button_function_play:                        SUBROUTINE
    BSR     ui_button_function_save_previous
    BRA     ui_button_play


; =============================================================================
; UI_BUTTON_EDIT_PLAY
; =============================================================================
; DESCRIPTION:
; Handles a 'Play' keypress while the UI is in 'Edit' mode.
;
; =============================================================================
ui_button_edit_play:                            SUBROUTINE
    BSR     ui_button_edit_save_previous
; Falls-through below.

; =============================================================================
; UI_BUTTON_PLAY
; =============================================================================
; DESCRIPTION:
; Sets the synth's user interface to 'Play' mode.
;
; =============================================================================
ui_button_play:                                 SUBROUTINE
    LDAA    #UI_MODE_PLAY
    STAA    ui_mode_memory_protect_state

; Reset operator status.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status

; Load the previous 'Play Mode' numeric key, and then jump to the
; numeric button handler.
    LDAB    ui_btn_numeric_previous_play_mode
    JMP     ui_button_numeric


; =============================================================================
; UI_BUTTON_FUNCTION_SAVE_PREVIOUS
; =============================================================================
; DESCRIPTION:
; This routine saves the previous numeric button pressed while the synth's UI
; was in 'Function' mode.
; @TODO: There are several behaviours not well understood here.
;
; =============================================================================
ui_button_function_save_previous:               SUBROUTINE
; If the test mode button combination state was previously set, don't save this
; state as the last-pressed button state.
; Decrement A to save this as function mode button 20 instead.
    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_TEST_ENTRY_COMBO
    BNE     .store_previous_function_mode_button

    DECA

.store_previous_function_mode_button:
    STAA    ui_btn_numeric_previous_fn_mode
    CMPA    #BUTTON_FUNCTION_6
    BCS     .store_previous_play_mode_button

    CMPA    #BUTTON_FUNCTION_11
    BCS     .clear_test_mode_button_combo_state

    CMPA    #BUTTON_FUNCTION_19
    BCC     .clear_test_mode_button_combo_state

.store_previous_play_mode_button:
    STAA    ui_btn_numeric_previous_play_mode

.clear_test_mode_button_combo_state:
    CLR     ui_test_mode_button_combo_state
    RTS


; =============================================================================
; UI_BUTTON_EDIT_SAVE_PREVIOUS
; =============================================================================
; DESCRIPTION:
; This routine saves the previous numeric button pressed while the synth's UI
; was in 'Edit' mode.
;
; =============================================================================
ui_button_edit_save_previous:                   SUBROUTINE
    LDAA    ui_btn_numeric_last_pressed
    STAA    ui_btn_numeric_previous_edit_mode
    CMPA    #BUTTON_EDIT_6
    BCS     .clear_key_transpose_mode_state

    CMPA    #BUTTON_EDIT_10
    BCC     .clear_key_transpose_mode_state

    STAA    ui_btn_numeric_previous_play_mode

.clear_key_transpose_mode_state:
    CLR     key_tranpose_set_mode_active
    RTS


; =============================================================================
; UI_BUTTON_NUMERIC
; =============================================================================
; LOCATION: 0xDF0C
;
; DESCRIPTION:
; Main user-interface handler subroutine for a front-panel button press.
; The buttons have already been assigned the appropriate codes by the main
; input handler subroutines. This subroutine calls the specific functionality
; associated with each button.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel numeric switch number code.
;          0-19: Edit Mode Buttons.
;         20-39: Function Mode Buttons.
;
; =============================================================================
ui_button_numeric:                              SUBROUTINE
    JSR     ui_button_check_test_mode_combination
    TBA
    JSR     jumpoff

    DC.B ui_button_edit_1_to_4_operator_enable - *
    DC.B 4
    DC.B ui_button_edit_5 - *
    DC.B 5
    DC.B ui_store_last_button_and_load_max_value - *
    DC.B 8
    DC.B ui_button_edit_9_pmd_amd - *
    DC.B 9
    DC.B ui_button_edit_10 - *
    DC.B 10
    DC.B ui_button_edit_11_operator_select - *
    DC.B 11
    DC.B ui_store_last_pressed_btn_and_load_max_value_jump - *
    DC.B 13
    DC.B ui_button_edit_14 - *
    DC.B 14
    DC.B ui_button_edit_15_16_jump - *
    DC.B 16
    DC.B ui_store_last_pressed_btn_and_load_max_value_jump - *
    DC.B 19
    DC.B ui_button_edit_20_jump - *
    DC.B 20
    DC.B ui_button_function_set_active_parameter_jump - *
    DC.B 25
    DC.B ui_button_function_6_jump - *
    DC.B 26
    DC.B ui_button_function_7_jump - *
    DC.B 27
    DC.B ui_button_function_set_active_parameter_jump - *
    DC.B 38
    DC.B ui_button_function_19_jump - *
    DC.B 39
    DC.B ui_button_function_20_jump - *
    DC.B 40
    DC.B ui_button_function_set_active_parameter_jump - *
    DC.B 0


; =============================================================================
; UI_BUTTON_EDIT_1_TO_4_OPERATOR_ENABLE
; =============================================================================
; DESCRIPTION:
; Toggles the operator enable status of the synth's operators.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel numeric button number.
;         In this case numbers 0-3.
;
; =============================================================================
ui_button_edit_1_to_4_operator_enable:          SUBROUTINE
; Use the triggering button number as an index into this variable.
; Increment the associated status byte, and then mask with '1' to 'toggle' the
; operator's status between '1' and '0'.
    LDX     #operator_4_enabled_status
    ABX
    LDAA    0,x
    INCA
    ANDA    #1
    STAA    0,x
    BNE     .operator_enabled

; Test if the currently selected operator was disabled.
    CMPB    operator_selected_src
    BNE     .set_patch_to_be_reloaded_and_exit

; If the operator was disabled, load the 'Button 11' value into ACCB, and then
; retrigger processing the numeric button input. This will select the next
; operator. This is done to ensure that a disabled operator is not 'selected'.
    LDAB    #BUTTON_EDIT_11
    BSR     ui_button_numeric
    BRA     .set_patch_to_be_reloaded_and_exit

.operator_enabled:
; Ensure that the currently selected operator is active.
; If not, trigger a 'Button 11' press, to cycle to the next operator.
    LDX     #operator_4_enabled_status
    LDAB    operator_selected_src
    ANDB    #%11
    ABX
    LDAA    0,x
    BNE     .set_patch_to_be_reloaded_and_exit

    LDAB    #BUTTON_EDIT_11
    BSR     ui_button_numeric

.set_patch_to_be_reloaded_and_exit:
    LDAA    #EVENT_RELOAD_PATCH
    STAA    main_patch_event_flag
    JSR     midi_sysex_tx_param_change_operator_enable

ui_button_edit_1_to_4_operator_enable_exit:
    RTS


; =============================================================================
; UI_BUTTON_EDIT_11_OPERATOR_SELECT
; =============================================================================
; DESCRIPTION:
; Handles the front-panel numeric button 11 being pressed when the synth is
; in 'Edit Mode'.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel numeric button number.
;
; =============================================================================
ui_button_edit_11_operator_select:              SUBROUTINE
    LDAB    operator_selected_src

; Loop over the operators until either an enabled operator is found, or the
; loop counter in ACCA reaches zero.
; If no operators are enabled, the end effect is that the selected operator
; will remain the same.
    LDAA    #4
.find_next_selected_operator_loop:
; Increment the selected operator index, and mask to perform a modulo 4
; operation, then test whether the newly selected operator is enabled.
    LDX     #operator_4_enabled_status
    INCB
    ANDB    #%11
    ABX
    TST     0,x
    BNE     .store_new_selected_operator

    DECA
    BNE     .find_next_selected_operator_loop

.store_new_selected_operator:
    STAB    operator_selected_src

; Load the last pressed numeric button to redraw the last shown UI screen.
; If this was the 'Key Transpose' mode, reset.
    LDAB    ui_btn_numeric_last_pressed
    CMPB    #BUTTON_EDIT_20
    BEQ     ui_button_edit_1_to_4_operator_enable_exit

    CLR     ui_btn_numeric_last_pressed
    BRA     ui_button_numeric


; =============================================================================
; UI_BUTTON_EDIT_20_JUMP
; Thunk subroutine to provide a reachable offset for the jump table.
; =============================================================================
ui_button_edit_20_jump:
    JMP     ui_button_edit_20_key_transpose

; =============================================================================
; UI_BUTTON_EDIT_15_16_JUMP
; =============================================================================
ui_button_edit_15_16_jump:
    JMP     ui_button_edit_15_16_select_eg_stage

; =============================================================================
; UI_STORE_LAST_PRESSED_BUTTON_AND_EXIT_JUMP
; =============================================================================
ui_store_last_pressed_btn_and_load_max_value_jump:
    JMP     ui_store_last_pressed_btn_and_load_max_value

; =============================================================================
; UI_GET_POINTER_TO_OPERATOR_JUMP
; =============================================================================
ui_get_pointer_to_operator_jump:
    JMP     ui_get_pointer_to_operator

; =============================================================================
; UI_STORE_EDIT_ACTIVE_PARAM_ADDRESS_JUMP
; =============================================================================
ui_store_edit_active_param_address_jump:
    JMP     ui_store_edit_active_param_address

; =============================================================================
; UI_BUTTON_FUNCTION_20_JUMP
; =============================================================================
ui_button_function_20_jump:
    JMP     ui_button_function_20

; =============================================================================
; UI_BUTTON_FUNCTION_SET_ACTIVE_PARAMETER_JUMP
; =============================================================================
ui_button_function_set_active_parameter_jump:
    JMP     ui_button_function_set_active_parameter

; =============================================================================
; UI_BUTTON_FUNCTION_7_JUMP
; =============================================================================
ui_button_function_7_jump:
    JMP     ui_button_function_7

; =============================================================================
; UI_BUTTON_FUNCTION_19_JUMP
; =============================================================================
ui_button_function_19_jump:
    JMP     ui_button_function_19

; =============================================================================
; UI_BUTTON_FUNCTION_7_JUMP
; =============================================================================
ui_button_function_6_jump:
    JMP     ui_button_function_6


; =============================================================================
; UI_BUTTON_EDIT_5
; =============================================================================
; DESCRIPTION:
; Handles the numeric button 5 being pressed when the synth is in 'Edit Mode'.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel numeric button number.
;
; =============================================================================
ui_button_edit_5:                               SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed
    BNE     .store_last_button_pressed

; Increment and mask this variable to toggle it between '1' and '0'.
    LDAA    ui_btn_edit_5_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_edit_5_sub_function

.store_last_button_pressed:
    STAB    ui_btn_numeric_last_pressed
    TST     ui_btn_edit_5_sub_function
    BNE     .load_value_base

    DECB

.load_value_base:
    BRA     ui_button_edit_load_max_value_offset_6


; =============================================================================
; UI_BUTTON_EDIT_9_PMD_AMD
; =============================================================================
; DESCRIPTION:
; Handles the numeric button 9 being pressed when the synth is in 'Edit Mode'.
; This cycles through the sub-functions associated with pitch, and amplitude
; modulation depth.
;
; =============================================================================
ui_button_edit_9_pmd_amd:                       SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed
    BNE     .set_edit_parameter_address

; @TODO: Verify why this check is performed.
; Ordinarily this scenario should be unreachable.
    LDAA    ui_mode_memory_protect_state
    CMPA    #UI_MODE_PLAY
    BEQ     .set_edit_parameter_address

    TST     ui_flag_disable_edit_btn_9_mode_select
    BNE     .set_edit_parameter_address

; Increment and mask this variable to toggle it between '1' and '0'.
    LDAA    ui_btn_edit_9_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_edit_9_sub_function

.set_edit_parameter_address:
    CLR     ui_flag_disable_edit_btn_9_mode_select
    STAB    ui_btn_numeric_last_pressed
    TST     ui_btn_edit_9_sub_function
    BEQ     ui_button_edit_load_max_value_offset_6

    LDX     #max_value_lfo_pitch_mod_depth
    BRA     ui_button_edit_get_active_parameter_address


; =============================================================================
; UI_STORE_LAST_BUTTON_AND_LOAD_MAX_VALUE
; =============================================================================
; DESCRIPTION:
; Stores the latest button press as the 'last' pressed numeric button, and then
; loads the maximum value for this button's associated 'edit parameter'.
;
; =============================================================================
ui_store_last_button_and_load_max_value:        SUBROUTINE
    STAB    ui_btn_numeric_last_pressed
; Fall-through below.

ui_button_edit_load_max_value_offset_6:         SUBROUTINE
; This point loads the maximum edit parameter value from the table with a
; negative offset of 6. The button code is doubled, and then 6 is effectively
; subtracted from the final address to get the pointer to the value.
; Example:
; Edit Button 5 (Button Code 4) Mode 1: Feedback:
;  4 << 2 = 8
;  8 - 6 = index 2 = Feedback.
    ASLB
    LDX     #table_max_param_values_edit_mode - 6
    BRA     ui_button_edit_load_max_value_index_in_accb


; =============================================================================
; UI_BUTTON_EDIT_10
; =============================================================================
; DESCRIPTION:
; Handles the numeric button 10 being pressed when in 'Edit Mode'.
;
; =============================================================================
ui_button_edit_10:                              SUBROUTINE
    CMPB    ui_btn_numeric_last_pressed
    BNE     .store_last_button_pressed

    LDAA    ui_btn_edit_10_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_edit_10_sub_function

.store_last_button_pressed:
    STAB    ui_btn_numeric_last_pressed
    TST     ui_btn_edit_10_sub_function
    BEQ     ui_button_edit_load_max_value_offset_6

    LDX     #max_value_lfo_pitch_mod_sens
    BRA     ui_button_edit_get_active_parameter_address


; =============================================================================
; UI_BUTTON_EDIT_14
; =============================================================================
; DESCRIPTION:
; Handles the numeric button 14 being pressed when in 'Edit Mode'.
;
; =============================================================================
ui_button_edit_14:                              SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed
    BNE     .store_last_button_pressed

; Increment, and then mask this value to toggle between '1', and '0'.
    LDAA    ui_btn_edit_14_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_edit_14_sub_function

.store_last_button_pressed:
    STAB    ui_btn_numeric_last_pressed
    TST     ui_btn_edit_14_sub_function
    BEQ     ui_button_edit_load_max_value_offset_8

    LDX     #max_value_oscillator_sync
    BRA     ui_button_edit_get_active_parameter_address


; =============================================================================
; UI_BUTTON_EDIT_20_KEY_TRANSPOSE
; =============================================================================
; DESCRIPTION:
; Sets the 'Key Transpose Set' mode as being active, causing the next keypress
; to set the transpose root.
;
; ARGUMENTS:
; Registers:
; * ACCB: The numerical code of the last-pressed button.

; =============================================================================
ui_button_edit_20_key_transpose:                SUBROUTINE
    STAB    ui_btn_numeric_last_pressed

    TST     ui_flag_blocks_key_transpose
    BNE     .clear_edit_parameter

    TST     patch_compare_mode_active
    BNE     .clear_edit_parameter

; Set the 'Key Transpose' mode as active.
    LDAB    #1
    STAB    <key_tranpose_set_mode_active

.clear_edit_parameter:
; Store the address of the 'null' edit parameter in the active edit parameter
; address pointer.
    LDX     #null_edit_parameter
    STX     ui_active_param_address

; Validate the current key transpose value.
    LDX     #patch_edit_key_transpose
    LDAA    #24
    JMP     ui_check_edit_parameter_against_max_value


; =============================================================================
; UI_BUTTON_EDIT_15_16_EG_STAGE
; =============================================================================
; DESCRIPTION:
; Selects either the EG rate, or level as the active edit parameter.
; Multiple successive presses selects the active EG stage.
;
; ARGUMENTS:
; Registers:
; * ACCB: The numerical code of the last-pressed button.
;
; =============================================================================
ui_button_edit_15_16_select_eg_stage:           SUBROUTINE
; If the last pressed button was identical to the previous, then increment
; the currently selected EG stage.
    CMPB    ui_btn_numeric_last_pressed
    BNE     ui_store_last_pressed_btn_and_load_max_value

    LDAA    ui_currently_selected_eg_stage
    INCA
    ANDA    #%11
    STAA    ui_currently_selected_eg_stage
; Falls-through below.

ui_store_last_pressed_btn_and_load_max_value:   SUBROUTINE
    STAB    ui_btn_numeric_last_pressed
; Falls-through below.

ui_button_edit_load_max_value_offset_8:         SUBROUTINE
; This point loads the maximum edit parameter value from the table with a
; negative offset of 8. The button code is doubled, and then 6 is effectively
; subtracted from the final address to get the pointer to the value.
    ASLB
    LDX     #table_max_param_values_edit_mode - 8
; Falls-through below.

ui_button_edit_load_max_value_index_in_accb:    SUBROUTINE
    ABX
; Falls-through below.

; =============================================================================
; UI_BUTTON_EDIT_GET_ACTIVE_PARAMETER_ADDRESS
; =============================================================================
; DESCRIPTION:
; Loads, and parses the entry in the edit parameter offset, and maximum value
; table, then stores the active parameter address, and maximum value.
; Based upon the offset value, this subroutine determines whether the
; parameter being edited is an operator EG value, and operator value, or a
; patch value.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the edit parameter offset, and maximum value.
;
; =============================================================================
ui_button_edit_get_active_parameter_address:    SUBROUTINE
    LDD     0,x
    STAB    ui_active_param_max_value
    TAB

; Branch if 69 or lower.
    CMPB    #69
    BCS     .add_offset_to_patch_buffer_address

    ANDB    #%111111

.add_offset_to_patch_buffer_address:
    LDX     #patch_buffer_edit
    ABX

; If bit 7 is free, this is a patch parameter.
    TSTA
    BPL     ui_store_edit_active_param_address

; If only bit 7 is set, this is an operator parameter.
    BITA    #%1000000
    BEQ     ui_get_pointer_to_operator

; If bit 7, and bit 6 are set, this is an EG stage parameter.
    LDAB    ui_currently_selected_eg_stage
    ABX

ui_get_pointer_to_operator:
    LDAA    operator_selected_src
    COMA
    ANDA    #%11
    LDAB    #$F
    MUL
    ABX

ui_store_edit_active_param_address:
    STX     ui_active_param_address
    BRA     ui_load_active_param_ptr_and_max_value


; =============================================================================
; UI_BUTTON_FUNCTION_6
; =============================================================================
; DESCRIPTION:
; Handles a press to button '6' when the synth is in function mode.
; This routine cycles through the sub-functions associated with this button.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel numeric button number.
;
; =============================================================================
ui_button_function_6:                           SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed
    BNE     .set_active_edit_parameter

; If the sub function is '1', test whether 'Sys Info' is available before
; incrementing the sub-function.
    LDAA    ui_btn_function_6_sub_function
    CMPA    #1
    BEQ     .is_sys_info_avail

    INCA

; After incrementing, compared the value against '3'.
; If the carry-bit is set, indicating it is equal or above, reset to '0'.
    CMPA    #3
    BCS     .store_sub_function

    CLRA
    BRA     .store_sub_function

.is_sys_info_avail:
; Test whether 'SYS INFO AVAIL' has been enabled.
; If this is not enabled, do not increment the sub-function to '2'.
; This is because MIDI transmission is not permitted if SysEx is disabled.
    TST     sys_info_avail
    BNE     .sys_info_available

; If SysEx transmission is disabled, toggle the value back to '0'.
    CLRA
    BRA     .store_sub_function

.sys_info_available:
; Increment the sub-function if SysEx transmission is enabled.
    INCA

.store_sub_function:
    STAA    ui_btn_function_6_sub_function
    TBA

.set_active_edit_parameter:
    TST     ui_btn_function_6_sub_function
    BEQ     ui_button_function_set_active_parameter

    ADDA    #16
    BRA     ui_button_function_set_active_parameter


; =============================================================================
; UI_BUTTON_FUNCTION_7
; =============================================================================
; DESCRIPTION:
; Handles a press to button '7' when the synth is in function mode.
;
; =============================================================================
ui_button_function_7:                           SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed
    BNE     ui_button_function_set_active_parameter

    LDAA    ui_btn_function_7_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_function_7_sub_function
    BRA     ui_button_function_set_active_parameter


; =============================================================================
; UI_BUTTON_FUNCTION_19
; =============================================================================
; DESCRIPTION:
; Handles a press to button '19' when the synth is in function mode.
; Thi
;
; =============================================================================
ui_button_function_19:                          SUBROUTINE
; If this button has been pressed twice in succession, cycle the sub-function.
    CMPB    ui_btn_numeric_last_pressed

; Test whether this button has been pressed twice in succession.
; If so, cycle through this button's 'sub-functions'.
    BNE     ui_button_function_set_active_parameter
    LDAA    ui_btn_function_19_sub_function
    INCA
    CMPA    #3
    BCS     .store_sub_function

    CLRA

.store_sub_function:
    STAA    ui_btn_function_19_sub_function
    TBA
    BRA     ui_button_function_set_active_parameter


; =============================================================================
; UI_BUTTON_FUNCTION_20
; =============================================================================
; DESCRIPTION:
; Handles a press to button '20' when the synth is in function mode.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel numeric button number.
;
; =============================================================================
ui_button_function_20:                          SUBROUTINE
    LDAA    #BUTTON_FUNCTION_20
    LDAB    #BUTTON_FUNCTION_20
; Falls-through below.

; =============================================================================
; UI_BUTTON_FUNCTION_SET_ACTIVE_PARAMETER
; =============================================================================
; LOCATION: 0xE0DC
;
; DESCRIPTION:
; This subroutine sets the currently selected 'Edit Parameter' and its
; associated maximum value when a numeric button is pressed while the synth is
; in 'Function Mode'.
;
; ARGUMENTS:
; Registers:
; * ACCA: The 'code' of the initial function mode button press which triggered
;         this changing of the current 'Edit Parameter'.
;         This will be used to look up the parameter pointer and maximum value
;         in the associated table.
;
; =============================================================================
ui_button_function_set_active_parameter:        SUBROUTINE
; '20' is subtracted from this value on account of the function mode
; button codes beginning at '20'.
    SUBA    #20

; Test whether the last button press was '23' (Function Mode Button 4/
; Portamento Mode).
; If the synth is in polyphonic mode, do not allow any editing of this
; parameter, as there is only one portamento mode available.
    CMPA    #BUTTON_FUNCTION_4 - 20
    BNE     .get_active_parameter_pointer

    TST     mono_poly
    BNE     .get_active_parameter_pointer

; Load the index for the 'Null' edit parameter.
    LDAA    #20

.get_active_parameter_pointer:
; Multiply the index by 3, since each entry in this table is 3 bytes long.
; It has the format:
; - 'Pointer to edit parameter' (2 bytes)
; - 'Maximum Value' (1 byte)
    STAB    ui_btn_numeric_last_pressed
    LDAB    #3
    MUL

    LDX     #table_max_parameter_values_function_mode
    ABX

; Store a pointer to the parameter currently being edited.
    LDD     0,x
    STD     ui_active_param_address

; Store the maximum value of the parameter currently being edited.
    LDAB    2,x
    STAB    ui_active_param_max_value
    CLR     ui_btn_function_19_patch_init_prompt
; Fall-through below.

; =============================================================================
; UI_LOAD_ACTIVE_PARAM_PTR_AND_MAX_VALUE
; =============================================================================
; LOCATION: 0xE100
;
; DESCRIPTION:
; Loads the active edit parameter pointer, and max value.
;
; =============================================================================
ui_load_active_param_ptr_and_max_value:         SUBROUTINE
    LDX     ui_active_param_address
    LDAA    ui_active_param_max_value
; Fall-through below.

; =============================================================================
; UI_CHECK_EDIT_PARAMETER_AGAINST_MAX_VALUE
; =============================================================================
; LOCATION: 0xE106
;
; DESCRIPTION:
; Validates the currently selected 'edit parameter' against its maximum
; allowed value. If it has exceeded the maximum value, reset it to '0'.
;
; =============================================================================
ui_check_edit_parameter_against_max_value:      SUBROUTINE
; Compare the current parameter value against the maximum.
; If it has exceeded the maximum, and thus set the carry bit, reset it to 0.
    CMPA    0,x
    BCC     .send_parameter_change

    CLR     0,x

.send_parameter_change:
; Send the newly active parameter via SysEx.
; This is performed to allow remote control of a separate DX9.
    JSR     midi_sysex_tx_param_change

    RTS

; =============================================================================
; Edit mode parameter offset, and max value table.
; This table contains an array of entries used to get a pointer to the
; currently selected 'Edit Mode' parameter, and its associated max value.
; The first byte of each entry is the offset of the parameter.
; If the offset is below 8, it is considered an envelope parameter.
; If the offset is below 21, it is considered an operator parameter.
; Otherwise it is considered a general patch parameter.
; The offset will be used accordingly to set up a pointer relative to the start
; of the patch edit buffer.
; The second byte is the maximum value for this parameter.
; =============================================================================
table_max_param_values_edit_mode:
    DC.B PATCH_ALGORITHM
    DC.B 7
    DC.B PATCH_FEEDBACK
    DC.B 7
    DC.B PATCH_LFO_WAVE
    DC.B 5
    DC.B PATCH_LFO_SPEED
    DC.B 99
    DC.B PATCH_LFO_DELAY
    DC.B 99
    DC.B PATCH_LFO_AMP_MOD_DEPTH
    DC.B 99
    DC.B PATCH_OP_AMP_MOD_SENSE | $80
    DC.B 3
    DC.B PATCH_OP_FREQ_COARSE | $80
    DC.B 31
    DC.B PATCH_OP_FREQ_FINE | $80
    DC.B 99
    DC.B PATCH_OP_DETUNE | $80
    DC.B 14
    DC.B PATCH_OP_EG_RATE_1 | $C0
    DC.B 99
    DC.B PATCH_OP_EG_LEVEL_1 | $C0
    DC.B 99
    DC.B PATCH_OP_KBD_SCALING_RATE | $80
    DC.B 7
    DC.B PATCH_OP_KBD_SCALE_LVL | $80
    DC.B 99
    DC.B PATCH_OP_LEVEL | $80
    DC.B 99
max_value_oscillator_sync:
    DC.B PATCH_OSC_SYNC
    DC.B 1
max_value_lfo_pitch_mod_depth:
    DC.B PATCH_LFO_PITCH_MOD_DEPTH
    DC.B 99
max_value_lfo_pitch_mod_sens:
    DC.B PATCH_LFO_PITCH_MOD_SENS
    DC.B 7

; =============================================================================
; Function Mode Parameter Max Value Table.
; This table contains an array of pointers to the 'Function Mode' parameters,
; and their maximum allowed values.
; This table is used by the UI button functions.
; =============================================================================
table_max_parameter_values_function_mode:
    DC.W master_tune
    DC.B 127
    DC.W mono_poly
    DC.B 1
    DC.W pitch_bend_range
    DC.B 12
    DC.W portamento_mode
    DC.B 1
    DC.W portamento_time
    DC.B 99
    DC.W midi_rx_channel
    DC.B 15
    DC.W null_edit_parameter
    DC.B 1
    DC.W null_edit_parameter
    DC.B 1
    DC.W null_edit_parameter
    DC.B 1
    DC.W tape_remote_output_polarity
    DC.B 1
    DC.W mod_wheel_range
    DC.B 99
    DC.W mod_wheel_assign
    DC.B 1
    DC.W mod_wheel_amp
    DC.B 1
    DC.W mod_wheel_eg_bias
    DC.B 1
    DC.W breath_control_range
    DC.B 99
    DC.W breath_control_assign
    DC.B 1
    DC.W breath_control_amp
    DC.B 1
    DC.W breath_control_eg_bias
    DC.B 1
    DC.W null_edit_parameter
    DC.B 1
    DC.W memory_protect
    DC.B 1
    DC.W null_edit_parameter
    DC.B 1
    DC.W sys_info_avail
    DC.B 1


; =============================================================================
; UI_CHECK_TEST_BTN_COMBO
; =============================================================================
; LOCATION: 0xE176
;
; DESCRIPTION:
; Tests whether the test mode button combination (Function + 10 + 20) are
; currently active.
;
; ARGUMENTS:
; Registers:
; * ACCA: UI Input Mode
; * ACCB: Front-panel numeric switch number code.
;
; RETURNS:
; * ACCB: If the test mode button combination is active, the corresponding
;         test mode button state will be returned in ACCB.
;
; =============================================================================
ui_button_check_test_mode_combination:          SUBROUTINE
    CMPB    #BUTTON_FUNCTION_10
    BEQ     .button_10_is_down

    CMPB    #BUTTON_FUNCTION_20
    BEQ     .button_20_is_down

.reset_test_mode_button_state:
; Reset the test button combination state.
    CLRA

.store_test_mode_button_state:
    STAA    <ui_test_mode_button_combo_state

.exit:
    RTS

.button_10_is_down:
    JSR     ui_button_check_test_mode_button_function
    TSTA
    BEQ     .reset_test_mode_button_state

    LDAA    #1
    BRA     .store_test_mode_button_state

.button_20_is_down:
; If the triggering button press was 'button 20', test whether button 10 was
; previously pressed, and the first stage of the 'test button combination'
; has been assigned.
    TST     ui_test_mode_button_combo_state
    BEQ     .exit

; Test whether the 'Store', and '10' buttons are currently being pressed.
    JSR     ui_button_check_test_mode_button_function
    TSTA
    BEQ     .reset_test_mode_button_state

    JSR     ui_button_check_test_mode_button_10
    TSTA
    BEQ     .reset_test_mode_button_state

; Set the UI Button State to display the Test Mode entry prompt.
    CLR     ui_test_mode_button_combo_state
    LDAB    #BUTTON_TEST_ENTRY_COMBO
    BRA     .exit


; =============================================================================
; UI_BUTTON_CHECK_TEST_MODE_BUTTON_FUNCTION
; =============================================================================
; LOCATION: 0xE1A4
;
; DESCRIPTION:
; Tests whether the 'Function' button is currently being pressed, as part of
; testing the test mode button combination.
;
; RETURNS:
; * ACCA: The state of the 'Function' button.
;
; =============================================================================
ui_button_check_test_mode_button_function:      SUBROUTINE
    LDAA    <io_port_1_data
    ANDA    #%11110000
    STAA    <io_port_1_data

    DELAY_SINGLE
    LDAA    <key_switch_scan_driver_input
    ANDA    #KEY_SWITCH_LINE_0_BUTTON_FUNCTION
    RTS


; =============================================================================
; UI_BUTTON_CHECK_TEST_MODE_BUTTON_10
; =============================================================================
; LOCATION: 0xE1B1
;
; DESCRIPTION:
; Tests whether the '10' button is currently being pressed, as part of
; testing the test mode button combination.
;
; RETURNS:
; * ACCA: The state of the '10' button.
;
; =============================================================================
ui_button_check_test_mode_button_10:            SUBROUTINE
    LDAA    <io_port_1_data
    ANDA    #%11110000
    ORAA    #KEY_SWITCH_SCAN_DRIVER_SOURCE_BUTTONS_2
    STAA    <io_port_1_data

    DELAY_SINGLE
    LDAA    <key_switch_scan_driver_input
    ANDA    #KEY_SWITCH_LINE_1_BUTTON_10
    RTS


; =============================================================================
; UI_PATCH_INIT_RECALL
; =============================================================================
; LOCATION: 0xE1C0
;
; DESCRIPTION:
; Performs the Patch 'Initialise'/'Recall' user-interface functionality.
;
; =============================================================================
ui_patch_init_recall:                           SUBROUTINE
    LDAA    ui_btn_function_19_sub_function
    BEQ     .edit_recall

    DECA
    BEQ     .patch_init

.exit:
    RTS

.edit_recall:
    JSR     patch_edit_recall
    BRA     .set_ui_to_edit_mode

.patch_init:
    JSR     patch_initialise
; Reset the selected operator.
    CLRA
    STAA    operator_selected_src

.set_ui_to_edit_mode:
; After initialising the patch, or recalling the compare buffer, set the
; synth's UI to 'Edit' mode.
    JSR     ui_button_function_edit
    BRA     .exit


; =============================================================================
; PATCH_COPY_EDIT_TO_COMPARE_AND_LOAD_CURRENT
; =============================================================================
; DESCRIPTION:
; Serialises the currently loaded patch in the edit buffer to the compare
; buffer, then loads the 'current' patch (based off the selected patch index)
; into the edit buffer.
;
; =============================================================================
patch_copy_edit_to_compare_and_load_current:    SUBROUTINE
    LDX     #patch_buffer_edit
    STX     <memcpy_ptr_src

    LDX     #patch_buffer_compare
    JSR     patch_serialise

    BRA     patch_get_ptr_and_deserialise


; =============================================================================
; PATCH_LOAD
; =============================================================================
; LOCATION: 0xE1E7
;
; DESCRIPTION:
; Initiates deserialisation of a patch from the synth's internal memory into
; the synth's edit buffer.
;
; ARGUMENTS:
; Registers:
; * ACCB: The index of the patch to load into the synth's patch memory,
;         starting at index 0.
;
; =============================================================================
patch_load:                                     SUBROUTINE
    CMPB    patch_index_current
    BNE     patch_load_store_edit_buffer_to_compare

; If the incoming patch number in ACCB is identical to the currently
; selected patch index, test whether the currently loaded patch has been
; modified. If not, exit.
    TST     patch_current_modified_flag
    BEQ     patch_load_exit

patch_load_store_edit_buffer_to_compare:
; Patch index is saved here.
    JSR     patch_set_new_index_and_copy_edit_to_compare
    JSR     midi_tx_program_change_current_patch
    JSR     midi_sysex_tx_bulk_data_single_patch

patch_load_clear_compare_mode_state:
    CLR     patch_compare_mode_active

patch_get_ptr_and_deserialise:
    JSR     patch_get_ptr_to_current
; Falls-through below.

; =============================================================================
; PATCH_DESERIALISE_TO_EDIT_FROM_PTR_AND_RELOAD
; =============================================================================
; LOCATION: 0xE200
;
; DESCRIPTION:
; Takes a pointer to a patch, and deserialises it into the synth's edit buffer.
; The flag is then set to force the activation of the newly loaded patch.
; This subroutine is the main point of loading a patch into memory.
; The loaded patch will also be validated in this routine.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the patch buffer to deserialise.
;
; =============================================================================
patch_deserialise_to_edit_from_ptr_and_reload:  SUBROUTINE
    STX     <memcpy_ptr_src

; The destination pointer is stored in the deserialise routine below.
    LDX     #patch_buffer_edit

; Forces patch reload.
    LDAB    #EVENT_HALT_VOICES_RELOAD_PATCH
    STAB    main_patch_event_flag
    JSR     patch_deserialise
    JSR     patch_validate

patch_load_exit:
    RTS


; =============================================================================
; PATCH_SAVE
; =============================================================================
; LOCATION: 0xE211
;
; DESCRIPTION:
; Serialises the patch edit buffer to the specified index into the synth's
; patch memory, saving the patch to the synth's non-volatile storage.
;
; ARGUMENTS:
; Registers:
; * ACCB: The index into the synth's patch memory to save the edit buffer to.
;
; =============================================================================
patch_save:                                     SUBROUTINE
    STAB    patch_index_current
    CLR     patch_current_modified_flag
    CLR     patch_compare_mode_active
    LDX     #patch_buffer_edit
    STX     <memcpy_ptr_src

; Get a pointer to the currently selected patch in the device's main patch
; memory buffer.
; This pointer is stored to the copy destination pointer in the
; 'patch_serialise' function.
    JSR     patch_get_ptr_to_current

; Force stopping of all voices, and reloading of the patch.
    LDAB    #EVENT_HALT_VOICES_RELOAD_PATCH
    STAB    main_patch_event_flag
    JMP     patch_serialise


; =============================================================================
; PATCH_RESTORE_EDIT_BUFFER_FROM_COMPARE
; =============================================================================
; LOCATION: 0xE22A
;
; DESCRIPTION:
; Deserialises the 'Patch Compare' buffer into the 'Patch Edit' buffer.
;
; =============================================================================
patch_restore_edit_buffer_from_compare:         SUBROUTINE
    LDX     #patch_buffer_compare
    BRA     patch_deserialise_to_edit_from_ptr_and_reload


; =============================================================================
; PATCH_SET_NEW_INDEX_AND_SAVE_EDIT_BUFFER_TO_COMPARE
; =============================================================================
; LOCATION: 0xE22F
;
; DESCRIPTION:
; This subroutine is invoked when changing patches.
; It sets the newly selected patch index, and if the currently loaded patch
; has been edited, it will backup the edit buffer by serialising it to the
; patch compare buffer.
;
; ARGUMENTS:
; Registers:
; * ACCB: The new patch index.
;
; =============================================================================
patch_set_new_index_and_copy_edit_to_compare:   SUBROUTINE
; If the patch in the edit buffer has not been modified, it will not be backed
; up to the compare buffer.
    TST     patch_current_modified_flag
    BEQ     .patch_unmodified

; Save the current patch index to the compare index, and set the current
; patch as being unmodified.
    LDAA    patch_index_current
    STAA    patch_index_compare
    STAB    patch_index_current
    CLR     patch_current_modified_flag

; Serialise the patch edit buffer to the compare buffer.
    LDX     #patch_buffer_edit
    STX     <memcpy_ptr_src
    LDX     #patch_buffer_compare
    JSR     patch_serialise

.exit:
    RTS

.patch_unmodified:
; If the patch is unmodified, simply update the selected patch index.
    STAB    patch_index_current
    BRA     .exit


; =============================================================================
; PATCH_EDIT_RECALL
; =============================================================================
; DESCRIPTION:
; Recalls a patch from the 'Patch Compare' buffer.
; This routine is called from the UI function mode menu.
;
; =============================================================================
patch_edit_recall:                              SUBROUTINE
    LDAA    patch_index_compare
    STAA    patch_index_current
    CLR     patch_compare_mode_active

; Set the patch edit buffer as having been modified.
    LDAA    #1
    STAA    patch_current_modified_flag
    JSR     midi_sysex_tx_recalled_patch

; Reset operator 'On/Off' status.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status
    BRA     patch_restore_edit_buffer_from_compare


; =============================================================================
; PATCH_INITIALISE
; =============================================================================
; LOCATION: 0xE26D
;
; DESCRIPTION:
; Initialises the patch edit buffer.
; If the currently loaded patch has been modified, it will copy the current
; patch edit buffer into the patch compare buffer.
;
; =============================================================================
patch_initialise:                               SUBROUTINE
    CLR     patch_compare_mode_active

; Setting the sign bit of the current patch index will cause the
; 'patch_load' to reload the init patch buffer.
    LDAB    #$80
    JSR     patch_set_new_index_and_copy_edit_to_compare
    JSR     midi_sysex_tx_bulk_data_send_init_voice

patch_init_edit_buffer:
; Reset the operator 'On/Off' status.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status

; Deserialise from the init patch buffer to the patch edit buffer.
    LDX     #patch_buffer_init_voice
    JMP     patch_deserialise_to_edit_from_ptr_and_reload

; =============================================================================
; Initialise Patch Buffer.
; This buffer contains the data to initialise the patch 'Edit Buffer'.
; =============================================================================
patch_buffer_init_voice:
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 1
    DC.B 0
    DC.B 7
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 1
    DC.B 0
    DC.B 7
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B 1
    DC.B 0
    DC.B 7
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B $63
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B $63
    DC.B 1
    DC.B 0
    DC.B 7
    DC.B 0
    DC.B 8
    DC.B $23
    DC.B 0
    DC.B 0
    DC.B 0
    DC.B $18
    DC.B 12


; =============================================================================
; PATCH_OPERATOR_EG_COPY
; =============================================================================
; LOCATION: 0xEC27
;
; DESCRIPTION:
; Copies the envelope settings from the currently selected operator, to the
; specified destination operator.
;
; ARGUMENTS:
; Registers:
; * ACCB: The number of the operator to copy the EG settings to.
;
; =============================================================================
patch_operator_eg_copy:                         SUBROUTINE
; Validate the specified operator number.
; If >= 4, exit.
    CMPB    #4
    BCC     .exit

    STAB    operator_selected_dest
    JSR     patch_operator_get_ptr
    STX     <memcpy_ptr_dest
    JSR     patch_operator_get_ptr_to_selected
    STX     <memcpy_ptr_src
    LDAB    #10
    JSR     memcpy

; Trigger a patch reload.
    LDAB    #EVENT_RELOAD_PATCH

; Set the patch edit buffer as having been modified.
    STAB    patch_current_modified_flag
    STAB    main_patch_event_flag

.exit:
    RTS


; =============================================================================
; UI_YES_NO
; =============================================================================
; LOCATION: 0xC3CF
;
; DESCRIPTION:
; Handles user input when the button pressed was 'Yes', or 'No'.
;
; ARGUMENTS:
; Registers:
; * ACCA: The UI Input Mode.
; * ACCB: The triggering button code. In this case, either YES(1), or NO(2).
;
; RETURNS:
; * CC:C: The CPU carry bit is set in the case that the subroutine was called
; after a function key press that prompts for a single 'Yes/No' answer. As
; opposed to an edit parameter that requires incrementing or decrementing.
; This is used by the calling function to determine whether it should
; fall-through to the increment/decrement routine.
;
; =============================================================================
ui_yes_no:                                      SUBROUTINE
    TBA

; If the last pressed numeric button was not a 'Function Mode' button, this
; will be caught in the jumpoff's first entry and ignored.
    LDAB    ui_btn_numeric_last_pressed
    JSR     jumpoff

    DC.B ui_yes_no_exit_numeric_parameter - *
    DC.B 25
    DC.B ui_yes_no_fn_btn_6 - *
    DC.B 26
    DC.B ui_yes_no_fn_btn_7_8_9 - *
    DC.B 29
    DC.B ui_yes_no_exit_numeric_parameter - *
    DC.B 38
    DC.B ui_yes_no_fn_btn_19 - *
    DC.B 39
    DC.B ui_yes_no_exit_numeric_parameter - *
    DC.B 40
    DC.B ui_yes_no_test_entry - *
    DC.B 41
    DC.B ui_yes_no_exit_numeric_parameter - *
    DC.B 0

; =============================================================================
; Exit, and clear the carry bit in the case that the parameter was numeric.
; =============================================================================
ui_yes_no_exit_numeric_parameter:               SUBROUTINE
    TAB
    CLC
    RTS


; =============================================================================
; UI_YES_NO_FN_BTN_6
; =============================================================================
; LOCATION: 0xE300
;
; DESCRIPTION:
; 'Yes/No' button handler when the synth is in function mode, and the previous
; front-panel button press was button '6'.
;
; ARGUMENTS:
; Registers:
; * ACCA: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
ui_yes_no_fn_btn_6:                             SUBROUTINE
; Test if the sub-function is the MIDI channel, or the 'Sys Info' status.
; If so, it is a numeric parameter which can be incremented, or decremented by
; the appropriate handler.
    LDAB    #2
    CMPB    ui_btn_function_6_sub_function
    BNE     ui_yes_no_exit_numeric_parameter

; Otherwise it is the SysEx transmission prompt.
; Test whether the last button was 'Yes'. If so, begin the bulk dump.
    CMPA    #INPUT_BUTTON_YES
    BNE     .exit

    JSR     midi_sysex_tx_bulk_data_all_patches

.exit:
    SEC
    RTS


; =============================================================================
; UI_YES_NO_FN_BTN_7_8_9
; =============================================================================
; LOCATION: 0xE310
;
; DESCRIPTION:
; 'Yes/No' button handler when the synth is in function mode, and the previous
; front-panel button press was button '7', '8', or '9'.
;
; ARGUMENTS:
; Registers:
; * ACCA: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
ui_yes_no_fn_btn_7_8_9:                         SUBROUTINE
    CMPA    #INPUT_BUTTON_YES
    BNE     .cancel

    JSR     tape_ui_jumpoff
    BRA     .exit

.cancel:
; Test whether button 7 has been pressed multiple times in sequence.
; If the triggering button press was not 7, nothing will happen here.
    LDAB    #BUTTON_FUNCTION_7
    CMPB    ui_btn_numeric_last_pressed
    BNE     .exit

; If so, cycle the button's 'sub function'.
; This is achieved by incrementing, and then masking with '1', since this is
; effectively toggling between two-states.
    LDAA    ui_btn_function_7_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_function_7_sub_function

.exit:
    SEC
    RTS


; =============================================================================
; UI_YES_NO_FN_BTN_19
; =============================================================================
; LOCATION: 0xE32B
;
; DESCRIPTION:
; 'Yes/No' button handler when the synth is in function mode, and the previous
; front-panel button press was button '19'.
;
; ARGUMENTS:
; Registers:
; * ACCA: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
ui_yes_no_fn_btn_19:                            SUBROUTINE
; If the function mode button 19 sub-function is to print the battery mode,
; yes/no has no effect, so exit.
    LDAB    #2
    CMPB    ui_btn_function_19_sub_function
    BEQ     .exit

; Test whether the 'Patch Init' prompt is active.
    TST     ui_btn_function_19_patch_init_prompt
    BEQ     .set_prompt_flag

; Since some user action (Yes/No) has been taken, clear the prompt flag,
; then test whether the button pressed was 'Yes'. If not, exit.
    CLR     ui_btn_function_19_patch_init_prompt
    CMPA    #INPUT_BUTTON_YES
    BNE     .exit

; If the button pressed was yes, jump to this subroutine, then return to
; set the carry flag and exit.
    JSR     ui_patch_init_recall
    BRA     .exit

.set_prompt_flag:
; If the button pressed was not 'Yes', proceed to cycle the sub function.
    CMPA    #INPUT_BUTTON_YES
    BNE     .cycle_button_sub_function

; If the button was yes, enable the 'Patch Init' prompt.
    STAA    <ui_btn_function_19_patch_init_prompt
    BRA     .exit

.cycle_button_sub_function:
; Cycle the button's 'sub function'.
; This is achieved by incrementing, and then masking with '1', since this is
; effectively toggling between two-states.
    LDAA    ui_btn_function_19_sub_function
    INCA
    ANDA    #1
    STAA    ui_btn_function_19_sub_function

.exit:
    SEC
    RTS


; =============================================================================
; UI_YES_NO_TEST_ENTRY
; =============================================================================
; LOCATION: 0xE356
;
; DESCRIPTION:
; 'Yes/No' button handler when the synth is presenting the 'Test Mode' entry
; prompt. The 'Yes' button will initiate the synth's diagnosic mode.
;
; ARGUMENTS:
; Registers:
; * ACCA: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
ui_yes_no_test_entry:                           SUBROUTINE
    CMPA    #INPUT_BUTTON_YES
    BNE     ui_test_entry_reload_patch_and_exit

    JSR     test_entry

ui_test_entry_reload_patch_and_exit:            SUBROUTINE
    CLR     ui_test_mode_button_combo_state
    JSR     ui_button_function_play
    LDAB    patch_index_current
    JSR     patch_load_store_edit_buffer_to_compare
    SEC

    RTS


; =============================================================================
; UI_INPUT_INCREMENT_DECREMENT
; =============================================================================
; LOCATION: 0xE36B
;
; DESCRIPTION:
; Handles incrementing, or decrementing the actively selected edit parameter.
; This subroutine is triggered by the main front-panel 'Yes/No' button input
; handler.
;
; ARGUMENTS:
; Registers:
; * ACCA: The UI Input Mode.
; * ACCB: The triggering button code. In this case, either YES(1), or NO(2).
;
; =============================================================================
ui_input_decrement:                             SUBROUTINE
    LDX     ui_active_param_address
    CPX     #master_tune
    BEQ     ui_input_exit

; Send a MIDI CC signal indicating the increment/decrement.
    JSR     midi_tx_cc_increment_decrement

ui_increment_decrement_parameter:
    TST     patch_compare_mode_active
    BEQ     .load_parameter_address

; This ensures that if 'Compare Mode' is active, only function parameters can
; be modified using the increment/decrement functionality.
    LDX     ui_active_param_address
    CPX     #null_edit_parameter
    BCS     ui_input_exit

.load_parameter_address:
    LDX     ui_active_param_address

; Decrement ACCB to convert it to a boolean value.
; 0 = Yes/Up, 1 = Down/No.
    DECB
    BNE     .decrement_parameter

; Increment the value of the actively edited parameter.
; If it is currently at its maximum, exit.
    LDAA    0,x
    CMPA    ui_active_param_max_value
    BEQ     ui_input_exit

    INCA
    BRA     ui_update_numeric_parameter

.decrement_parameter:
; Decrement the value of the actively edited parameter.
; If it is already at zero, exit.
    LDAA    0,x
    BEQ     ui_input_exit

    DECA
    BRA     ui_update_numeric_parameter


; =============================================================================
; UI_INPUT_SLIDER
; =============================================================================
; LOCATION: 0xE39A
;
; DESCRIPTION:
; This subroutine handles editing parameters via the front-panel slider.
; It is called by the main slider input handler subroutine. It works by
; loading the maximum value of the currently edited parameter, scaling it
; according to the analog slider input, and then storing it.
;
; =============================================================================
ui_input_slider:                                SUBROUTINE
    TST     patch_compare_mode_active
    BEQ     .test_if_slider_updated

; This tests if the currently selected edit parameter is an 'Edit Mode'
; parameter, as opposed to a 'Function Mode' one. Since the function mode
; parameter addresses are higher than the null value address.
; The purpose of this check is so that function parameters can be edited while
; the synth is in 'Compare Mode', but not edit parameters.
    LDX     ui_active_param_address
    CPX     #null_edit_parameter
    BCS     ui_input_exit

.test_if_slider_updated:
; Check whether the slider input has actually changed since the last input,
; by comparing the new value against a previous recorded value.
; If this has changed, store the new input.
; This is necessary since the previous value used in the ADC processing
; routine is overwritten, and cannot be used for this purpose.
    LDAB    analog_input_slider
    CMPB    analog_input_slider_previous
    BEQ     ui_input_exit

    STAB    analog_input_slider_previous

; Load the maximum value of the parameter currently being edited.
    LDAA    ui_active_param_max_value
    INCA

; Decrement in the case of overflow.
    BNE     .scale_parameter
    DECA

.scale_parameter:
; Scale the param by incrementing the maximum value, and then multiplying it
; by the analog value obtained from the slider input.
; The result will be stored in ACCD. The MSB will hold a scaled version of
; the maximum, which will become the new parameter value.
    MUL
    LDX     ui_active_param_address
; falls-through below.

; =============================================================================
; UI_UPDATE_NUMERIC_PARAMETER
; =============================================================================
; DESCRIPTION:
; Handles updating a numeric edit parameter.
; This subroutine is called via the front-panel increment/decrement, and
; slider input handler routines.
;
; ARGUMENTS:
; Registers:
; * IX:   The active parameter address.
; * ACCA: The new parameter value.
;
; =============================================================================
ui_update_numeric_parameter:                    SUBROUTINE
; Check if the value has been updated by the previous operation.
; If so, store the newly updated value.
    CMPA    0,x
    BEQ     ui_input_exit

    STAA    0,x

; Trigger the reloading of the patch data to the EGS chip.
    LDAA    #EVENT_RELOAD_PATCH
    STAA    main_patch_event_flag

; If the previous front-panel button press that initiated this action
; originated from a function parameter button, branch.
    LDAA    ui_btn_numeric_last_pressed
    CMPA    #BUTTON_EDIT_20
    BCC     .function_parameter

; Set the patch edit buffer as having been modified.
    LDAA    #1
    STAA    patch_current_modified_flag
    BRA     ui_input_exit

.function_parameter:
; If the parameter being updated is the synth's polyphony mode, stop all
; voices, and reset the voice buffers.
    CMPA    #BUTTON_FUNCTION_2
    BEQ     .reset_voices

; If the MIDI channel is updated, reset all voices.
    CMPA    #BUTTON_FUNCTION_6
    BNE     ui_input_exit

    TST     ui_btn_function_6_sub_function
    BNE     ui_input_exit

.reset_voices:
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count

ui_input_exit:
    RTS


; =============================================================================
; UI_PRINT_UPDATE_LED_AND_MENU
; =============================================================================
; DESCRIPTION:
; Updates the LED patch number, and prints the UI to the LCD.
; This subroutine is used to update the synth's UI after various user actions.
;
; =============================================================================
ui_print_update_led_and_menu:                   SUBROUTINE
    BSR     led_print_patch_number
    BSR     ui_print
    RTS


; =============================================================================
; LED_PRINT_PATCH_NUMBER
; =============================================================================
; LOCATION: 0xE3F2
;
; DESCRIPTION:
; Prints the currently selected patch number to the synth's LED display.
;
; =============================================================================
led_print_patch_number:                         SUBROUTINE
    LDAB    patch_index_current

; The patch index is set to 128 after initialising the patch
    BMI     led_print_patch_number_exit

; @TODO: When is the patch index equal to '20'?
    CMPB    #20
    BNE     .print_patch_number_jumpoff

; Since the patch index is incremented below, this will reset the index to '0'.
    SUBB    #21

.print_patch_number_jumpoff:
; Increment the patch number since its internal representation is 0-indexed.
; This will be used to jump to functions based upon whether the number is
; below '10', '20', or equal to '20'.
    INCB
    JSR     jumpoff

    DC.B led_print_patch_number_below_10 - *
    DC.B 10
    DC.B led_print_patch_number_below_20 - *
    DC.B 20
    DC.B led_print_patch_number_20 - *
    DC.B 0


; =============================================================================
; LED_PRINT_PATCH_NUMBER_BELOW_10
; =============================================================================
; LOCATION: 0xE407
;
; DESCRIPTION:
; Prints the currently selected patch number if it below '10'
;
; =============================================================================
led_print_patch_number_below_10:                SUBROUTINE
; Load the LED code for a blank 7-segment display (0xFF) for LED1.
    LDAA    #$FF
    BRA     led_write_digit_1_lookup_digit_2


; =============================================================================
; LED_PRINT_PATCH_NUMBER_BELOW_20
; =============================================================================
; LOCATION: 0xE40B
;
; DESCRIPTION:
; Prints the currently selected patch number if it below '20'
;
; =============================================================================
led_print_patch_number_below_20:                SUBROUTINE
; Load the 7-segment display LED code for '1' (0xF9) for LED1.
; Subtract '10' from the number to get the number to print to LED2.
    LDAA    #LED_DIGIT_1
    SUBB    #10
    BRA     led_write_digit_1_lookup_digit_2


; =============================================================================
; LED_PRINT_PATCH_NUMBER_20
; =============================================================================
; LOCATION: 0xE411
;
; DESCRIPTION:
; Prints the currently selected patch number if it is '20'
;
; =============================================================================
led_print_patch_number_20:                      SUBROUTINE
; Load the 7-segment display LED code for '2' (0xA4) for LED1.
; Clear ACCB, and then fall-through to lookup digit 2.
    LDAA    #LED_DIGIT_2
    CLRB
; Falls-through below.

; =============================================================================
; LED_WRITE_DIGIT_1_LOOKUP_DIGIT_2
; =============================================================================
; LOCATION: 0xE414
;
; DESCRIPTION:
; Prints the first digit of the LED, and looks up digit 2 based upon the
; value passed in ACCB.
;
; ARGUMENTS:
; Registers:
; * ACCA: The LED digit data to write to the first LED digit.
;         This data is obtained from the LED mapping table.
; * ACCB: The number to write to the SECond LED digit.
;         This will be looked up from the LED mapping table.
;
; =============================================================================
led_write_digit_1_lookup_digit_2:               SUBROUTINE
    STAA    led_contents
    TST     patch_compare_mode_active
    BNE     .lookup_led_digit_2

    STAA    <led_1

.lookup_led_digit_2:
; Lookup the second digit in the LED mapping table.
    LDX     #table_led_digit_map
    ABX
    LDAA    0,x

; If the active patch has been edited, don't perform a check for whether
; the patch compare mode is active.
    TST     patch_current_modified_flag
    BEQ     .write_led_digit_2_contents

; If the compare mode is active, mask bit 7 of the second LED digit to
; display the compare mode marker.
    TST     patch_compare_mode_active
    BNE     .write_led_digit_2_contents

    ANDA    #%1111111

.write_led_digit_2_contents:
    STAA    led_contents + 1
    TST     patch_compare_mode_active
    BNE     .exit

    STAA    <led_2

.exit:
    RTS

led_print_patch_number_exit:
    LDD     #checksum_remainder_byte
    BRA     led_write_digit_1_lookup_digit_2


; =============================================================================
; LED Constants
; =============================================================================
LED_DIGIT_0                                     EQU %11000000
LED_DIGIT_1                                     EQU %11111001
LED_DIGIT_2                                     EQU %10100100

; =============================================================================
; LED segment mapping table.
; These values represent the codes for rendering the numbers 0-9 on the synth's
; two 7-segment LEDs.
; This is primarily used when printing the patch number to the LED display.
; Note: Digit '9' differs from the DX7: The bottom segment on the DX9 is lit.
;
; Each bit in these bitmasks corresponds to a segment of the LED:
;  0:  Top
;  1:  Right top
;  2:  Right bottom
;  3:  Bottom
;  4:  Left bottom
;  5:  Left top
;  6:  Middle
;  7:  -
; =============================================================================
table_led_digit_map:
    DC.B LED_DIGIT_0
    DC.B LED_DIGIT_1
    DC.B LED_DIGIT_2
    DC.B %10110000
    DC.B %10011001
    DC.B %10010010
    DC.B %10000010
    DC.B %11111000
    DC.B %10000000
    DC.B %10010000


; =============================================================================
; UI_PRINT
; =============================================================================
; LOCATION: 0xE44A
;
; DESCRIPTION:
; Main entry point to the synth's menu functionality.
; This subroutine will print the user-interface containing the currently
; active mode, the parameter currently being edited, and its value.
;
; =============================================================================
ui_print:                                       SUBROUTINE
; Clear LCD 'next' buffer prior to printing menu.
; The reason for iterating backwards is that the print pointer will be
; placed at the start of the buffer for the following print subroutine.
    LDX     #lcd_buffer_next_end
    LDAA    #'
.clear_lcd_loop:
    DEX
    STAA    0,x
    CPX     #lcd_buffer_next
    BNE     .clear_lcd_loop

    STX     <memcpy_ptr_dest

; Jump to the correct menu function based upon the current UI mode, and
; memory protection flags.
    LDAB    ui_mode_memory_protect_state

; If ACCB > 10, clear.
    CMPB    #11
    BCS     .menu_jumpoff

    CLRB

.menu_jumpoff:
    JSR     jumpoff_indexed

; =============================================================================
; UI Printing Functions.
; =============================================================================
    DC.B ui_print_function_mode - *
    DC.B ui_print_edit_mode - *
    DC.B ui_print_play_mode - *
    DC.B .exit - *

; =============================================================================
; UI Menu Functions: Memory Protect Disabled.
; =============================================================================
    DC.B .exit - *
    DC.B ui_print_eg_copy_mode - *
    DC.B ui_print_memory_store_mode - *
    DC.B .exit - *

; =============================================================================
; UI Menu Functions: Memory Protect Enabled.
; =============================================================================
    DC.B .exit - *
    DC.B ui_print_eg_copy_mode - *
    DC.B ui_print_memory_protected - *

.exit:
    RTS


; =============================================================================
; UI_PRINT_MEMORY_STORE_MODE
; =============================================================================
; DESCRIPTION:
; Prints the main UI menu when the synth's UI is in 'Store' mode, and the
; synth's memory protection is disabled.
;
; =============================================================================
ui_print_memory_store_mode:                     SUBROUTINE
    LDX     #str_memory_store
    BRA     ui_print_copy_string_and_update


; =============================================================================
; UI_PRINT_MEMORY_PROTECTED
; =============================================================================
; DESCRIPTION:
; Prints the main UI menu when the synth's UI is in 'Store' mode, and the
; synth's memory protection is enabled.
;
; =============================================================================
ui_print_memory_protected:                      SUBROUTINE
    LDX     #str_memory_protect
; Falls-through below.

; =============================================================================
; UI_PRINT_COPY_STRING_AND_UPDATE
; =============================================================================
; DESCRIPTION:
; Performs a string copy and updates the LCD, as part of the synth's main
; UI functionality.
;
; =============================================================================
ui_print_copy_string_and_update:                SUBROUTINE
    JSR     lcd_strcpy
    JMP     ui_update_lcd


; =============================================================================
; UI_PRINT_EG_COPY_MODE
; =============================================================================
; LOCATION: 0xE47E
;
; DESCRIPTION:
; Prints the 'EG COPY' menu dialog when the synth is in EG Copy mode.
;
; =============================================================================
ui_print_eg_copy_mode:                          SUBROUTINE
    LDX     #str_eg_copy
    JSR     lcd_strcpy

    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_from_op_to_op
    JSR     lcd_strcpy

; Store the position for the source EG number on the LCD in the copy ptr.
    LDX     #lcd_buffer_next + 23
    STX     <memcpy_ptr_dest

; Print the selected operator number.
    LDAA    operator_selected_src
    ANDA    #%11
    INCA    ; Increment, since the number is zero-based.
    JSR     lcd_print_number_single_digit

; Load the destination operator.
; Check whether this is uninitialised (0xFF).
; If so, exit without printing.
    LDAA    operator_selected_dest
    BMI     .exit

; Store the position for the dest EG number on the LCD in the copy ptr.
    LDX     #lcd_buffer_next + 30
    STX     <memcpy_ptr_dest
    INCA    ; Increment, since the number is zero-based.
    JSR     lcd_print_number_single_digit

; Reset this value so that when the destination operator button is released
; the UI will show the '?' value again.
    LDAA    #$FF
    STAA    operator_selected_dest

.exit:
    JMP     ui_update_lcd


; =============================================================================
; UI_PRINT_EDIT_MODE
; =============================================================================
; LOCATION: 0xE4B3
;
; DESCRIPTION:
; Prints the 'Edit Mode' user-interface.
; This contains the information about the current algorithm, the operator
; enabled status, and the EG edit interface.
;
; =============================================================================
ui_print_edit_mode:                             SUBROUTINE
    LDX     #str_fragment_alg
    JSR     lcd_strcpy

; Print the current patch's algorithm.
    LDAA    patch_edit_algorithm
    ANDA    #7
    INCA
    CLRB
    JSR     lcd_print_number_two_digits

; Print the enabled status of each individual operator.
; The 'Print Single Number' routine will print a '1', or '0' to indicate
; the status of each operator. Incrementing the LCD write pointer with
; each iteration.
    LDX     #lcd_buffer_next + 7
    STX     <memcpy_ptr_dest

; Print the enabled status of each individual operator.
; The 'Print Single Number' routine will print a '1', or '0' to indicate
; the status of each operator. Incrementing the LCD write pointer with
; each iteration.
    LDX     #operator_4_enabled_status

.print_operator_enabled_loop:
    LDAA    0,x
    ANDA    #1
    JSR     lcd_print_number_single_digit
    INX
    CPX     #ui_mode_memory_protect_state
    BNE     .print_operator_enabled_loop

    LDAB    ui_btn_numeric_last_pressed
    CMPB    #BUTTON_EDIT_10
    BNE     .was_last_button_below_12

    TST     ui_btn_edit_10_sub_function
    BEQ     .print_selected_operator

.was_last_button_below_12:
; If the carry flag is set, it means that the last button pressed was below 12.
    CMPB    #BUTTON_EDIT_12
    BCS     ui_print_parameter

    CMPB    #BUTTON_EDIT_14
    BNE     .was_last_button_in_function_mode

    TST     ui_btn_edit_14_sub_function
    BNE     ui_print_parameter

.was_last_button_in_function_mode:
; If the carry flag is clear, it means that the last button press registered
; was in function mode.
    CMPB    #BUTTON_EDIT_20
    BCC     ui_print_parameter

.print_selected_operator:
; Print the selected operator to the LCD.
; Prints 'OP' by directly copying these two bytes to the LCD buffer in IX,
; then prints the operator number by adding an ASCII '1' to the value of
; the currently selected operator.
    LDX     #$4F50
    STX     lcd_buffer_next + 13

    LDAA    operator_selected_src
    ANDA    #%11
    ADDA    #'1
    STAA    lcd_buffer_next + 15

    CMPB    #BUTTON_EDIT_15
    BCS     ui_print_parameter

    CMPB    #BUTTON_EDIT_17
    BCC     ui_print_parameter

; Print the currently selected EG stage.
    LDAA    ui_currently_selected_eg_stage
    ANDA    #%11
    ADDA    #'1
    STAA    lcd_buffer_next + 26

; Call the main menu print subroutine.
; This will print the currently selected parameter and its value.
    BRA     ui_print_parameter


; =============================================================================
; UI_PRINT_FUNCTION_MODE
; =============================================================================
; LOCATION: 0xE519
;
; DESCRIPTION:
; Prints the main user-interface when the synth is in 'Function Mode'.
; This subroutine will print the function mode header, the parameter currently
; being edited, and its value.
; This subroutine is also responsible for printing the 'patch init', and
; 'test mode entry' prompts.
;
; =============================================================================
ui_print_function_mode:                         SUBROUTINE
    LDAB    ui_btn_numeric_last_pressed

; If the 'TEST MODE ENTRY' prompt is active, print this message and exit.
    CMPB    #BUTTON_TEST_ENTRY_COMBO
    BNE     .print_header

    LDX     #str_test_mode_prompt
    JSR     lcd_strcpy
    JMP     lcd_update

.print_header:
    LDX     #str_function_control
    JSR     lcd_strcpy

; If the initialise patch prompt is active, print this message and exit.
; Otherwise proceed to the main menu print subroutine.
    TST     ui_btn_function_19_patch_init_prompt
    BEQ     ui_print_parameter

    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_are_you_sure
    JSR     lcd_strcpy
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PLAY_MODE
; =============================================================================
; LOCATION: 0xE542
;
; DESCRIPTION:
; Prints the main user-interface when the synth is in 'Memory Select Mode'.
;
; =============================================================================
ui_print_play_mode:                             SUBROUTINE
    LDX     #str_memory_select
    JSR     lcd_strcpy
; Falls-through to print menu.


; =============================================================================
; UI_PRINT_PARAMETER
; =============================================================================
; DESCRIPTION:
; Prints the currently selected edit parameter, and its value to the LCD.
; This routine works by finding the correct offset into the string table for
; the active parameter, based upon the last numeric button pressed.
; The string table entry for the particular parameters are encoded with a
; reference to the correct UI subroutine to call to print the parameter value.
;
; =============================================================================
ui_print_parameter:                             SUBROUTINE
; Set the LCD memcpy pointer to the start of line 2.
    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest

; Load the last numeric button pressed, and subtract '4' from this value.
; This happens because buttons 1-4 in 'Edit mode' don't trigger UI changes.
    LDAB    ui_btn_numeric_last_pressed
    SUBB    #4

; If value 6 (10): Button 11 (Operator Select), update the LCD and exit.
    CMPB    #BUTTON_EDIT_11 - 4
    BEQ     .update_lcd_without_change

; If the button value is above 6 (Button 11), branch.
    BCC     .button_is_above_11

; If ACCB == 0, the triggering button is Edit Mode Button 5.
    TSTB
    BNE     .is_edit_mode_button_9

; Value 0 (4) = Edit Mode Button 5.
; Test the value of the Edit Button 5 sub-status.
; 0 = Algorithm, 1 = Feedback.
    TST     ui_btn_edit_5_sub_function
    BEQ     .is_string_index_printable

.is_edit_mode_button_9:
    CMPB    #BUTTON_EDIT_9 - 4
    BNE     .is_edit_mode_button_10

; Value 4 (8) = Edit Mode Button 9.
; Test the value of the Edit Button 9 sub-status.
; 0 = LFO Amp Mod Depth, 1 = LFO Pitch Mod Depth.
    TST     ui_btn_edit_9_sub_function
    BEQ     .increment_button_number_to_get_string_pointer

; Load the string table index for 'LFO Pitch Mod Depth'
    LDAB    #38
    BRA     .is_string_index_printable

.is_edit_mode_button_10:
    CMPB    #BUTTON_EDIT_10 - 4
    BNE     .increment_button_number_to_get_string_pointer

; value 5 (9) = Edit Mode Button 10.
; Test the value of the Edit Button 10 sub-status.
; 0 = Amp Mod Sensitivity, 1 = Pitch Mod Sensitivity.
    TST     ui_btn_edit_10_sub_function
    BEQ     .increment_button_number_to_get_string_pointer

; Load the string table index for 'Pitch Mod Sens'.
    LDAB    #39
    BRA     .is_string_index_printable

.increment_button_number_to_get_string_pointer:
    INCB
    BRA     .is_string_index_printable

.update_lcd_without_change:
    CLRB
    BRA     .print_parameter_value

.button_is_above_11:
    CMPB    #BUTTON_EDIT_14 - 4
    BNE     .is_function_mode_button_6

; Value 9 (13) = Button 14 (Detune/Osc Sync).
; Test the value of the Edit Button 14 sub-status.
; 0 = Detune, 1 = Oscillator Sync.
    TST     ui_btn_edit_14_sub_function
    BEQ     .is_string_index_printable

; Load the string table index for 'Osc Key Sync'.
    LDAB    #37
    BRA     .is_string_index_printable

.is_function_mode_button_6:
    CMPB    #BUTTON_FUNCTION_6 - 4
    BNE     .is_function_mode_button_7

; Value 21 (25) = Function Mode Button 6.
; Test the value of the Function Button 6 sub-status.
; 0 = MIDI Channel, 1 = Sys Info, 2 = MIDI Transmit.
    LDAA    ui_btn_function_6_sub_function
    BEQ     .is_string_index_printable

    CMPA    #1
    BNE     .load_midi_transmit_string_index

; Load the string table index for 'Sys Info'.
    LDAB    #43
    BRA     .is_string_index_printable

.load_midi_transmit_string_index:
; Load the string table index for 'MIDI TRANSMIT ?'
    LDAB    #44
    BRA     .is_string_index_printable

.is_function_mode_button_7:
    CMPB    #BUTTON_FUNCTION_7 - 4
    BNE     .is_function_mode_button_19

; Value 22 (26) = Function Mode Button 7.
; Test the value of the Function Button 7 sub-status.
; 0 = Save Tape, 1 = Verify Tape.
    TST     ui_btn_function_7_sub_function
    BEQ     .is_string_index_printable

; Load the string table index for 'VERIFY TAPE ?'.
    LDAB    #42
    BRA     .is_string_index_printable

.is_function_mode_button_19:
    CMPB    #BUTTON_FUNCTION_19 - 4
    BNE     .is_string_index_printable

; Value 34 (38) = Function mode button 19.
; Test the value of the Function Button 19 sub-status.
; 0 = Edit Recall, 1 = Voice Init, 2 = Battery Voltage.
    LDAA    ui_btn_function_19_sub_function
    BEQ     .is_string_index_printable

    DECA
    BNE     .load_battery_voltage_string_index

; Load the string table index for 'VOICE INIT ?'.
    LDAB    #40
    BRA     .is_string_index_printable

.load_battery_voltage_string_index:
; Load the string table index for the 'BATTERY VOLT=' string.
    LDAB    #41
    BRA     *+2

.is_string_index_printable:
; If the string table index is over 44, the param is not printable.
; In this case, clear ACCB.
    CMPB    #45
    BCS     .print_parameter_name

    CLRB

.print_parameter_name:
; Print the parameter name to line 2 of the LCD screen.
    ASLB
    LDX     #table_ui_print_param_name_string_ptrs
    ABX
    LDX     0,x
    JSR     lcd_strcpy

; After the parameter name has been printed, print the parameter value.
; If ACCB less than 12, branch, otherwise clear the index.
; This index will be used as an offset into a table of printing routines.
; These routines are used to correctly print the parameter.
    CMPB    #12
    BCS     .print_parameter_value

    CLRB

.print_parameter_value:
; This is where the parameter value is printed.
; The following table contains pointers to the various functions used to
; print the parameter values.
; Most parameters (value over 12) do not require any specialised printing
; routine, so in this case the LCD will just be updated.
    LDX     #table_ui_print_param_functions
    ASLB
    ABX
    LDX     0,x
    JMP     0,x

table_ui_print_param_functions:
    DC.W ui_update_lcd
    DC.W ui_print_parameter_value_numeric
    DC.W ui_print_parameter_value_on_off
    DC.W ui_print_parameter_value_osc_freq
    DC.W ui_print_parameter_value_osc_detune
    DC.W ui_print_parameter_value_key_transpose
    DC.W ui_print_parameter_value_battery_voltage
    DC.W ui_print_parameter_value_mono_poly
    DC.W ui_print_parameter_value_portamento_mode
    DC.W ui_print_parameter_value_lfo
    DC.W ui_print_parameter_value_sys_info
    DC.W menu_print_param_equals_and_incremented_numeric_value


; =============================================================================
; UI_PRINT_PARAM_VALUE_EQUALS_AND_LOAD_VALUE
; =============================================================================
; DESCRIPTION:
; Prints an 'equals' to the LCD buffer, and then laods the currently active
; edit parameter.
;
; ARGUMENTS:
; Memory:
; * ui_active_param_address: The address of the selected edit parameter.
;
; RETURNS:
; * ACCA: The value of the selected edit parameter.
;
; =============================================================================
ui_print_param_value_equals_and_load_value:     SUBROUTINE
    LDAA    #'=
; Falls-through below.

; =============================================================================
; UI_PRINT_PARAM_VALUE_SEPARATOR_CHARACTER
; =============================================================================
; DESCRIPTION:
; Prints the specified separator charactor to the LCD buffer, and then loads
; the selected edit parameter.
;
; ARGUMENTS:
; Registers:
; * ACCA: The separator character to print.
;
; RETURNS:
; * IX:   The address of the selected edit parameter.
; * ACCA: The value of the selected edit parameter.
;
; =============================================================================
ui_print_param_value_separator_character:       SUBROUTINE
    LDX     #(lcd_buffer_next + 28)

ui_print_separator_and_load_active_param:
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest

ui_load_active_param_value:
    LDX     ui_active_param_address
    LDAA    0,x

    RTS


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_NUMERIC
; =============================================================================
; DESCRIPTION:
; Prints a numeric parameter to the LCD.
; This subroutine is used when the currently active edit parameter is numeric.
;
; =============================================================================
ui_print_parameter_value_numeric:               SUBROUTINE
    BSR     ui_print_param_value_equals_and_load_value
    JSR     lcd_print_number_three_digits
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_ON_OFF
; =============================================================================
; DESCRIPTION:
; Prints a boolean 'On/Off' parameter to the LCD.
; This subroutine is used when the currently active edit parameter is
; toggled on, and off.
;
; =============================================================================
ui_print_parameter_value_on_off:                SUBROUTINE
    LDAA    #':
    BSR     ui_print_param_value_separator_character
    LDX     #str_fragment_on
    TSTA
    BNE     .print_on_off_string

    LDX     #str_fragment_off

.print_on_off_string:
    JSR     lcd_strcpy
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_OSC_FREQ
; =============================================================================
; DESCRIPTION:
; Prints the oscillator frequency to the LCD.
;
; =============================================================================
ui_print_parameter_value_osc_freq:              SUBROUTINE
; Print the equals sign, and set the destination pointer at the correct
; place for the following LCD operations.
    LDAA    #'=
    LDX     #lcd_buffer_next + 24
    BSR     ui_print_separator_and_load_active_param
    LDAA    operator_selected_src
    BITA    #1
    BEQ     .operator_2_or_4_selected

; At this point X points to 'ui_active_param_address'.
    INX
    XGDX
    ANDB    #%11111110
    XGDX
    DEX
    BRA     .is_coarse_frequency_zero

.operator_2_or_4_selected:
    XGDX
    ANDB    #%11111110
    XGDX

.is_coarse_frequency_zero:
    LDAA    0,x
    BEQ     .coarse_frequency_is_zero

; For coarse frequencies above 0, the final operator ratio value displayed is
;   (100 * FREQ_COARSE) + (FREQ_COARSE * FREQ_FINE)
    LDAB    1,x
    ADDB    #100
    MUL

    CLR     lcd_print_number_print_zero_flag
    CLR     lcd_print_number_divisor

; Count the number of thousands in the operator ratio value to construct a
; printable string.
; This is done by looping, subtracting 1000 with each iteration, until the
; result is negative. The final 1000 value is then re-added.
.count_thousands_loop:
    SUBD    #1000
    BCS     .re_add_thousand

    INC     lcd_print_number_print_zero_flag
    BRA     .count_thousands_loop

.re_add_thousand:
    ADDD    #1000

; Count the number of hundreds using the same method.
.count_hundreds_loop:
    SUBD    #100
    BCS     .re_add_hundred

    INC     lcd_print_number_divisor
    BRA     .count_hundreds_loop

.re_add_hundred:
    ADDD    #100

    PSHB
    LDAA    <lcd_print_number_print_zero_flag
    LDAB    #10
    MUL
    ADDB    <lcd_print_number_divisor
    TBA
    JSR     lcd_print_number_three_digits

    LDAB    #'.
    JSR     lcd_store_character_and_increment_ptr
    PULA

    JSR     lcd_print_number_two_digits
    JMP     lcd_update

.coarse_frequency_is_zero:
; For a coarse frequency of 0, the final frequency value is
;   50 + ((FREQ_COARSE + 1 ) * (FREQ_FINE >> 1))
    CLRA
    JSR     lcd_print_number_three_digits
    LDAB    #'.
    JSR     lcd_store_character_and_increment_ptr

    LDAA    1,x
    LSRA
    ADDA    #50

    JSR     lcd_print_number_two_digits
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_OSC_DETUNE
; =============================================================================
; DESCRIPTION:
; Prints the value of the 'Oscillator Detune' parameter.
;
; =============================================================================
ui_print_parameter_value_osc_detune:            SUBROUTINE
    JSR     ui_print_param_value_equals_and_load_value
    SUBA    #7
    BHI     .detune_value_positive

    BMI     .detune_value_negative

; If the value is zero, print the value without the leading '+', or '-'.
    JSR     lcd_print_number_three_digits
    BRA     .update_lcd_and_exit

.detune_value_positive:
    LDAB    #'+
    JSR     lcd_store_character_and_increment_ptr
    BRA     .print_detune_value

.detune_value_negative:
    LDAB    #'-
    JSR     lcd_store_character_and_increment_ptr
    NEGA

.print_detune_value:
    CLRB
    JSR     lcd_print_number_two_digits

.update_lcd_and_exit:
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_KEY_TRANSPOSE
; =============================================================================
; DESCRIPTION:
; Prints the value of the 'Key Transpose' function parameter.
;
; =============================================================================
ui_print_parameter_value_key_transpose:         SUBROUTINE
    JSR     ui_print_param_value_equals_and_load_value
    LDAB    patch_edit_key_transpose

    LDAA    #49

; Subtract 12 with each iteration, until the value goes below zero.
; This will determine the octave of the root key transpose note.
.get_octave_loop:
    INCA
    SUBB    #12
    BCC     .get_octave_loop

    STAA    lcd_buffer_next+$1F

; Add 12 back to take into account the subtraction of '12' that overflowed.
    ADDB    #12

; Use this value as an index into the note name array.
    ASLB
    LDX     #str_note_names
    ABX
    LDD     0,x
    STD     lcd_buffer_next + 29
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_BATTERY_VOLTAGE
; =============================================================================
; DESCRIPTION:
; Prints the synth's battery voltage to the synth's LCD screen.
;
; ARGUMENTS:
; Memory:
; * analog_input_battery_voltage: The battery voltage, as read on reset.
;
; =============================================================================
ui_print_parameter_value_battery_voltage:       SUBROUTINE
    LDAB    analog_input_battery_voltage
    LDAA    #5
    MUL

    ADDA    #'0
    STAA    lcd_buffer_next + 29

    LDAA    #'.
    STAA    lcd_buffer_next + 30

    LDAA    #10
    MUL
    ADDA    #'0
    STAA    lcd_buffer_next + 31
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_MONO_POLY
; =============================================================================
; DESCRIPTION:
; Prints the synth's polyphony setting to the LCD screen.
;
; =============================================================================
ui_print_parameter_value_mono_poly:             SUBROUTINE
    JSR     ui_load_active_param_value
    LDX     #str_mono_mode
    TSTA
    BNE     ui_lcd_copy_and_update

    LDX     #str_poly_mode
; Falls-through below.

; =============================================================================
; UI_LCD_COPY_AND_UPDATE
; =============================================================================
; DESCRIPTION:
; Convenience subroutine to print the current parameter value string to the LCD.
;
; ARGUMENTS:
; Registers:
; * IX:   The string to print to the LCD.
;
; Memory:
; * memcpy_pointer_dest: The destination in memory to copy the string to.
;
; =============================================================================
ui_lcd_copy_and_update:                         SUBROUTINE
    JSR     lcd_strcpy
    JMP     lcd_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_PORTAMENTO_MODE
; =============================================================================
; DESCRIPTION:
; Prints the synth's currently selected portamento mode to the LCD screen.
;
; REGISTERS MODIFIED:
; * IX
;
; =============================================================================
ui_print_parameter_value_portamento_mode:       SUBROUTINE
    TST     mono_poly
    BNE     .synth_is_mono

    LDX     #str_full_time_porta
    BRA     ui_lcd_copy_and_update

.synth_is_mono:
    JSR     ui_load_active_param_value
    LDX     #str_fingered_porta
    TSTA
    BNE     ui_lcd_copy_and_update

    LDX     #str_full_time_porta
    BRA     ui_lcd_copy_and_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_LFO
; =============================================================================
; DESCRIPTION:
; Prints the synth's currently selected LFO wave to the LCD screen.
;
; =============================================================================
ui_print_parameter_value_lfo:                   SUBROUTINE
    LDAA    #':
    LDX     #(lcd_buffer_next + 24)
    JSR     ui_print_separator_and_load_active_param
    CMPA    #6
    BCS     .print_lfo_wave_name

    CLRA

.print_lfo_wave_name:
    LDX     #table_str_lfo_names
    TAB
    ASLB
    ABX
    LDX     0,x
    BRA     ui_lcd_copy_and_update


; =============================================================================
; UI_PRINT_PARAMETER_VALUE_SYS_INFO
; =============================================================================
; DESCRIPTION:
; Prints the value of the SysEx 'Sys Info Avail' setting.
;
; =============================================================================
ui_print_parameter_value_sys_info:              SUBROUTINE
    JSR     ui_load_active_param_value
    LDX     #str_sys_info_unavail + 2
    TSTA
    BNE     ui_lcd_copy_and_update

    LDX     #str_sys_info_unavail
    BRA     ui_lcd_copy_and_update


menu_print_param_equals_and_incremented_numeric_value:
    JSR     ui_print_param_value_equals_and_load_value
    INCA
    JSR     lcd_print_number_three_digits
; Falls-through to update LCD.

; =============================================================================
; UI_UPDATE_LCD
; =============================================================================
; LOCATION: 0xE744
;
; DESCRIPTION:
; Thunk routine responsible for updating the LCD contents after calling the
; main menu subroutines.
;
; =============================================================================
ui_update_lcd:                                  SUBROUTINE
    JMP     lcd_update

table_str_lfo_names:
    DC.W str_triangle
    DC.W str_saw_down
    DC.W str_saw_up
    DC.W str_square
    DC.W str_sine
    DC.W str_s_hold

table_ui_print_param_name_string_ptrs:
    DC.W str_algorithm_select
    DC.W str_feedback
    DC.W str_lfo_wave
    DC.W str_lfo_speed
    DC.W str_lfo_delay
    DC.W str_lfo_am_depth
    DC.W str_a_mod_sens
    DC.W str_freq_coarse
    DC.W str_freq_fine
    DC.W str_osc_detune
    DC.W str_eg_rate
    DC.W str_eg_level
    DC.W str_rate_scaling
    DC.W str_lvl_scaling
    DC.W str_output_level
    DC.W str_middle_c
    DC.W str_master_tune
    DC.W str_print_mono_poly
    DC.W str_p_bend_range
    DC.W str_print_portamento_mode
    DC.W str_porta_time
    DC.W str_midi_ch
    DC.W str_save_to_tape
    DC.W str_load_from_tape
    DC.W str_load_single
    DC.W str_tape_remote
    DC.W str_wheel_range
    DC.W str_wheel_pitch
    DC.W str_wheel_amp
    DC.W str_wheel_eg_b
    DC.W str_breath_range
    DC.W str_breath_pitch
    DC.W str_breath_amp
    DC.W str_breath_eg_b
    DC.W str_edit_recall
    DC.W str_mem_protect
    DC.W str_test_mode_prompt
    DC.W str_osc_key_sync
    DC.W str_lfo_pm_depth
    DC.W str_p_mod_sens
    DC.W str_voice_init
    DC.W str_battery_voltage
    DC.W str_verify_tape
    DC.W str_sys_info
    DC.W str_midi_transmit

str_function_control:                   DC "FUNCTION CONTROL", 0
str_eg_copy:                            DC "EG COPY", 0
str_memory_select:                      DC.B STR_FRAGMENT_OFFSET_MEMORY
                                        DC.B STR_FRAGMENT_OFFSET_SELECT
                                        DC.B 0

str_memory_store:                       DC.B STR_FRAGMENT_OFFSET_MEMORY
str_store:                              DC "STORE", 0

str_memory_protect:                     DC.B STR_FRAGMENT_OFFSET_MEMORY
                                        DC "PROTECT", 0

str_from_op_to_op:                      DC "from OP  to OP?", 0

str_algorithm_select:                   DC.B STR_FRAGMENT_OFFSET_ALG
                                        DC "ORITHM "
                                        DC.B STR_FRAGMENT_OFFSET_SELECT
                                        DC.B 0

str_feedback:                           DC "FEEDBACK"
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_lfo_speed:                          DC.B STR_FRAGMENT_OFFSET_LFO
                                        DC "SPEED"
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_lfo_wave:                           DC.B STR_FRAGMENT_OFFSET_LFO
                                        DC "WAVE"
                                        DC.B PRINT_PARAM_FUNCTION_LFO_WAVE

str_lfo_delay:                          DC.B STR_FRAGMENT_OFFSET_LFO
                                        DC "DELAY"
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_lfo_pm_depth:                       DC.B STR_FRAGMENT_OFFSET_LFO
                                        DC "PM"
                                        DC.B STR_FRAGMENT_OFFSET_DEPTH
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_lfo_am_depth:                       DC.B STR_FRAGMENT_OFFSET_LFO
                                        DC "AM"
                                        DC.B STR_FRAGMENT_OFFSET_DEPTH
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_a_mod_sens:                         DC "A MOD SENS."
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_p_mod_sens:                         DC "P MOD SENS."
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_freq_coarse:                        DC "F COARSE"
                                        DC.B PRINT_PARAM_FUNCTION_OSC_FREQ

str_freq_fine:                          DC "F FINE"
                                        DC.B PRINT_PARAM_FUNCTION_OSC_FREQ

str_osc_detune:                         DC "OSC DE"
                                        DC.B STR_FRAGMENT_OFFSET_TUNE
                                        DC.B PRINT_PARAM_FUNCTION_OSC_DETUNE

str_eg_rate:                            DC.B STR_FRAGMENT_OFFSET_EG
                                        DC.B '
                                        DC.B STR_FRAGMENT_OFFSET_RATE
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_eg_level:                           DC.B STR_FRAGMENT_OFFSET_EG
                                        DC.B '
                                        DC.B STR_FRAGMENT_OFFSET_LEVEL
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_rate_scaling:                       DC.B STR_FRAGMENT_OFFSET_RATE
                                        DC.B STR_FRAGMENT_OFFSET_SCALING
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_lvl_scaling:                        DC.B STR_FRAGMENT_OFFSET_LVL
                                        DC.B STR_FRAGMENT_OFFSET_SCALING
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_output_level:                       DC "OUTPUT "
                                        DC.B STR_FRAGMENT_OFFSET_LEVEL
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_middle_c:                           DC "MIDDLE C"
                                        DC.B PRINT_PARAM_FUNCTION_KEY_TRANSPOSE

str_master_tune:                        DC "MASTER "
                                        DC.B STR_FRAGMENT_OFFSET_TUNE
                                        DC.B '

str_adj:                                DC "ADJ", 0

str_poly_mode:                          DC "POLY"
                                        DC.B STR_FRAGMENT_OFFSET_MODE
                                        DC.B 0

str_mono_mode:                          DC "MONO"
                                        DC.B STR_FRAGMENT_OFFSET_MODE
str_print_mono_poly:                    DC.B PRINT_PARAM_FUNCTION_MONO_POLY

str_p_bend_range:                       DC "P BEND "
                                        DC.B STR_FRAGMENT_OFFSET_RANGE
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_full_time_porta:                    DC "FULL TIME "
                                        DC.B STR_FRAGMENT_OFFSET_PORTA
                                        DC.B 0

str_fingered_porta:                     DC "FINGERED "
                                        DC.B STR_FRAGMENT_OFFSET_PORTA
str_print_portamento_mode:              DC.B PRINT_PARAM_FUNCTION_PORTAMENTO_MODE

str_porta_time:                         DC.B STR_FRAGMENT_OFFSET_PORTA
                                        DC.B '
                                        DC "TIME"
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_midi_ch:                            DC "MIDI CH"
                                        DC.B PRINT_PARAM_FUNCTION_MIDI_CHANNEL

str_sys_info:                           DC "SYS INFO "
                                        DC.B PRINT_PARAM_FUNCTION_AVAIL_UNAVAIL

str_sys_info_unavail:                   DC "UNAVAIL", 0

str_midi_transmit:                      DC " MIDI TRANSMIT ?", 0

str_mem_protect:                        DC "MEM. PROTECT"
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_wheel_range:                        DC.B STR_FRAGMENT_OFFSET_WHEEL
                                        DC.B STR_FRAGMENT_OFFSET_RANGE
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_wheel_pitch:                        DC.B STR_FRAGMENT_OFFSET_WHEEL
                                        DC.B STR_FRAGMENT_OFFSET_PITCH
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_wheel_amp:                          DC.B STR_FRAGMENT_OFFSET_WHEEL
                                        DC.B STR_FRAGMENT_OFFSET_AMP
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_wheel_eg_b:                         DC.B STR_FRAGMENT_OFFSET_WHEEL
                                        DC.B STR_FRAGMENT_OFFSET_EG_B
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_breath_range:                       DC.B STR_FRAGMENT_OFFSET_BREATH
                                        DC.B STR_FRAGMENT_OFFSET_RANGE
                                        DC.B PRINT_PARAM_FUNCTION_NUMERIC

str_breath_pitch:                       DC.B STR_FRAGMENT_OFFSET_BREATH
                                        DC.B STR_FRAGMENT_OFFSET_PITCH
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_breath_amp:                         DC.B STR_FRAGMENT_OFFSET_BREATH
                                        DC.B STR_FRAGMENT_OFFSET_AMP
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_breath_eg_b:                        DC.B STR_FRAGMENT_OFFSET_BREATH
                                        DC.B STR_FRAGMENT_OFFSET_EG_B
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_save_to_tape:                       DC "SAVE TO TAPE ?", 0
str_verify_tape:                        DC "VERIFY TAPE ?", 0
str_load_from_tape:                     DC "LOAD FROM TAPE ?", 0
str_load_single:                        DC "LOAD SINGLE ?", 0
str_tape_remote:                        DC "TAPE REMOTE"
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_edit_recall:                        DC "EDIT RECALL ?", 0
str_voice_init:                         DC "VOICE INIT ?", 0
str_battery_voltage:                    DC "BATTERY VOLT="
                                        DC.B PRINT_PARAM_FUNCTION_BATTERY_VOLTAGE

str_osc_key_sync:                       DC "OSC KEY SYNC"
                                        DC.B PRINT_PARAM_FUNCTION_BOOLEAN

str_test_mode_prompt:                   DC "TEST MODE ENTRY  ARE YOU SURE ? ", 0
str_are_you_sure:                       DC "ARE YOU SURE ?", 0
str_triangle:                           DC "TRIANGLE", 0
str_saw_down:                           DC "SAW DWN", 0
str_saw_up:                             DC "SAW UP", 0
str_square:                             DC "SQUARE", 0
str_sine:                               DC "SINE", 0
str_s_hold:                             DC "S/HOLD", 0

; =============================================================================
; String Fragment Table.
; The DX9 firmware uses an novel method for saving space in the string table.
; It stores commonly printed 'fragments' of strings, which can be reused in
; regular strings.
; If the LCD string copy function encounters a byte with a value above 0x80, it
; treats this byte as an offset from the start of the 'string fragment table',
; and will then use this offset to load, and copy the specified 'fragment'.
; The 'start' offset below is 128 bytes offset from the start of the table so
; that the string copy code does not require any pointer arithmetic.
; The string copy function will add the offset to this pointer to find the
; specified fragment.
; This functionality is used in the DX100, and TX81Z, most likely others.
; It is not used in the DX7.
; =============================================================================
string_fragment_offset_start:           EQU (#str_fragment_table_start - 0x80)

str_fragment_table_start:

str_fragment_memory:                    DC "MEMORY ", 0
str_fragment_select:                    DC "SELECT", 0
str_fragment_alg:                       DC "ALG", 0
str_fragment_lfo:                       DC "LFO ", 0
str_fragment_depth:                     DC " DEPTH", 0
str_fragment_pitch:                     DC "PITCH ", 0
str_fragment_eg:                        DC "EG ", 0
str_fragment_rate:                      DC "RATE ", 0
str_fragment_level:                     DC "LEVEL", 0
str_fragment_lvl:                       DC "LVL ", 0
str_fragment_scaling:                   DC "SCALING", 0
str_fragment_tune:                      DC "TUNE", 0
str_fragment_mode:                      DC " MODE", 0
str_fragment_range:                     DC "RANGE", 0
str_fragment_porta:                     DC "PORTA", 0
str_fragment_wheel:                     DC "WHEEL ", 0
str_fragment_breath:                    DC "BREATH ", 0
str_fragment_amp:                       DC "AMP", 0
str_fragment_eg_b:                      DC "EG B.", 0
str_fragment_on:                        DC " ON", 0
str_fragment_off:                       DC "OFF", 0
str_note_names:                         DC "C C#D D#E F F#G G#A A#B "

STR_FRAGMENT_OFFSET_ALG:                EQU (str_fragment_alg - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_AMP:                EQU (str_fragment_amp - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_BREATH:             EQU (str_fragment_breath - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_DEPTH:              EQU (str_fragment_depth - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_EG:                 EQU (str_fragment_eg - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_EG_B:               EQU (str_fragment_eg_b - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_LEVEL:              EQU (str_fragment_level - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_LFO:                EQU (str_fragment_lfo - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_LVL:                EQU (str_fragment_lvl - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_MEMORY:             EQU (str_fragment_memory - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_MODE:               EQU (str_fragment_mode - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_PITCH:              EQU (str_fragment_pitch - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_PORTA:              EQU (str_fragment_porta - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_RANGE:              EQU (str_fragment_range - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_RATE:               EQU (str_fragment_rate - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_SCALING:            EQU (str_fragment_scaling - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_SELECT:             EQU (str_fragment_select - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_TUNE:               EQU (str_fragment_tune - #string_fragment_offset_start)
STR_FRAGMENT_OFFSET_WHEEL:              EQU (str_fragment_wheel - #string_fragment_offset_start)


; =============================================================================
; TAPE_UI_JUMPOFF
; =============================================================================
; LOCATION: 0xEA66
;
; DESCRIPTION:
; Initiates the tape-related function specified by the last keypress.
; This subroutine is initiated by pressing the 'Yes' front-panel switch to
; confirm a prompt raised by pressing the tape-related keys in function mode.
;
; =============================================================================
tape_ui_jumpoff:                                SUBROUTINE
    sei
    JSR     midi_reset

; Disable LED output.
    LDAA    #$FF
    STAA    <led_1
    STAA    <led_2

; Set the tape remote port output to low, to avoid triggering any tape
; actions prematurely.
    JSR     tape_remote_output_low

; Call the appropriate tape-function based on the last keypress.
    LDAB    ui_btn_numeric_last_pressed
    JSR     jumpoff

    DC.B tape_output_all - *
    DC.B 27
    DC.B tape_input_all_jump - *
    DC.B 28
    DC.B tape_input_single_jump - *
    DC.B 29
    DC.B tape_remote - *
    DC.B 0


; =============================================================================
; Thunk function used to perform a jump to a function that isn't within 255
; bytes of the main tape UI jumpoff.
; =============================================================================
tape_input_single_jump:
    JMP     tape_input_single


; =============================================================================
; Thunk function used to perform a jump to a function that isn't within 255
; bytes of the main tape UI jumpoff.
; =============================================================================
tape_input_all_jump:
    JMP     tape_input_all


; =============================================================================
; TAPE_OUTPUT_ALL
; =============================================================================
; DESCRIPTION:
; Outputs all the synth's internal patch memory over the synth's cassette
; interface.
;
; ARGUMENTS:
; Memory:
; * ui_btn_function_7_sub_function: Determines whether this function will
;    begin verification of the tape data, or will begin patch output.
;
; =============================================================================
tape_output_all:                                SUBROUTINE
; Test whether the button 7 sub-function is to output, or verify.
    TST     ui_btn_function_7_sub_function
    BEQ     .tape_output_sub_function_selected

    JMP     tape_verify

.tape_output_sub_function_selected:
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_dest
    LDX     #str_from_mem_to_tape
    JSR     lcd_strcpy
    JSR     lcd_update

; Read front-panel input to determine the next action.
; If 'No' is pressed, the tape UI actions are aborted.
; If 'Yes' is pressed, the operation proceeeds.
; If the 'Remote' button is pressed, toggle the remote output polarity,
; and loop back to wait for further input.
.tape_output_all_is_remote_button_pressed:
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_10
    BEQ     .tape_output_all_remote_button_pressed

    CMPB    #INPUT_BUTTON_NO
    BEQ     tape_remote

    CMPB    #INPUT_BUTTON_YES
; If the 'Yes' button has not been pressed by this point, loop back to
; await user input.
    BNE     .tape_output_all_is_remote_button_pressed

    BRA     .tape_output_clear_lcd

.tape_output_all_remote_button_pressed:
    JSR     tape_remote_toggle_output_polarity
    BRA     .tape_output_all_is_remote_button_pressed

.tape_output_clear_lcd:
    LDX     #(lcd_buffer_next + 26)
    LDAA    #'
    LDAB    #6

.tape_output_clear_lcd_loop:
    STAA    0,x
    INX
    DECB
    BNE     .tape_output_clear_lcd_loop

    JSR     lcd_update
    JSR     tape_remote_output_high
    CLR     tape_function_aborted_flag
    LDAB    #4
    LDX     #0

.tape_output_all_wait_for_abort_loop:
    TIMD    #KEY_SWITCH_LINE_1_BUTTON_10, key_switch_scan_driver_input
    BNE     tape_remote

    DEX
    BNE     .tape_output_all_wait_for_abort_loop

    DECB
    BNE     .tape_output_all_wait_for_abort_loop

    CLRA
    STAA    tape_patch_output_counter

.patch_output_loop:
; Print the patch number to the LCD.
    LDX     #(lcd_buffer_next + 29)
    STX     <memcpy_ptr_dest
    INCA
    JSR     lcd_print_number_three_digits
    JSR     lcd_update

; Output the patch.
    LDAA    tape_patch_output_counter
    JSR     patch_copy_to_tape_buffer
    JSR     tape_calculate_patch_checksum
    STD     tape_patch_checksum
    JSR     tape_output_patch
    TST     tape_function_aborted_flag
    BNE     tape_remote

    LDAA    tape_patch_output_counter
    INCA
    STAA    tape_patch_output_counter
    CMPA    #20
    BNE     .patch_output_loop

    JSR     tape_remote_output_low
    BRA     tape_verify

tape_remote:
    JSR     tape_remote_output_low
    CLI

    RTS


; =============================================================================
; TAPE_VERIFY
; =============================================================================
; DESCRIPTION:
; Reads all 20 patches from the cassette interface, verifying each one as it is
; input. An error message will be printed in the case that verification fails.
;
; =============================================================================
tape_verify:                                    SUBROUTINE
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_dest
    LDX     #str_verify_tape_ready
    JSR     lcd_strcpy
    JSR     lcd_update

; Read front-panel input to determine the next action.
; If 'No' is pressed, the tape UI actions are aborted.
; If 'Yes' is pressed, the operation proceeeds.
; If the 'Remote' button is pressed, toggle the remote output polarity,
; and loop back to wait for further input.
.tape_verify_is_remote_button_pressed:
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_10
    BEQ     .tape_verify_remote_button_pressed

    BRA     .tape_verify_is_no_button_pressed

.tape_verify_remote_button_pressed:
    JMP     .tape_verify_toggle_remote_output

.tape_verify_is_no_button_pressed:
    CMPB    #INPUT_BUTTON_NO
    BNE     .tape_verify_is_yes_button_pressed

    JMP     .tape_verify_aborted

.tape_verify_is_yes_button_pressed:
    CMPB    #INPUT_BUTTON_YES
; If the 'Yes' button has not been pressed by this point, loop back to
; await user input.
    BNE     .tape_verify_is_remote_button_pressed

; Initialise the verification process.
; Clear a space in the LCD buffer with 0x14 (@TODO: Verify?)
; Pull the tape remote output high, clear the tape function abort flag, and
; clear the verify patch index.
    LDX     #(lcd_buffer_next + 26)
    LDAA    #$14
    LDAB    #6

.tape_verify_clear_lcd_loop:
    STAA    0,x
    INX
    DECB
    BNE     .tape_verify_clear_lcd_loop

    JSR     lcd_update
    JSR     tape_remote_output_high

    CLR     tape_function_aborted_flag

    CLRA
    STAA    tape_patch_index

; Verify an individual patch.
; Start by printing the patch number.
.verify_patch_loop:
    LDX     #(lcd_buffer_next + 29)
    STX     <memcpy_ptr_dest
    INCA
    JSR     lcd_print_number_three_digits
    JSR     lcd_update
    JSR     tape_input_patch

    TST     tape_function_aborted_flag
    BNE     .tape_verify_aborted

    LDAA    tape_patch_index
    CMPA    tape_patch_output_counter
    BNE     .tape_verify_print_error_message

    JSR     tape_calculate_patch_checksum
    SUBD    tape_patch_checksum
    BNE     .tape_verify_print_error_message

    JSR     tape_verify_patch
; This flag being set indicates an error condition returned from the
; previous function call. If a received byte was found to be non-equal when
; compared against the current patch, the zero CPU flag will not be set.
    BNE     .tape_verify_print_error_message

    LDAA    tape_patch_index
    INCA
    STAA    tape_patch_index
    CMPA    #20
    BNE     .verify_patch_loop

; Print the 'Ok' string to line 2.
    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_ok
    JSR     lcd_strcpy
    JSR     lcd_update

; Loop for 8 * 0x10000, then exit the tape routines.
    JSR     tape_remote_output_low

    LDAB    #8
    LDX     #0
.delay_loop:
    DEX
    BNE     .delay_loop

    DECB
    BNE     .delay_loop

; Print the verification complete message.
    JSR     lcd_clear
    LDX     #str_function_control_verify
    JSR     lcd_strcpy
    JSR     lcd_update

; Exit to the main menu.
    CLI
    INS
    INS
    INS
    INS
    JMP     led_print_patch_number

.tape_verify_aborted:
    JSR     tape_remote_output_low
    CLI
    RTS

.tape_verify_toggle_remote_output:
    JSR     tape_remote_toggle_output_polarity
    JMP     .tape_verify_is_remote_button_pressed

.tape_verify_print_error_message:
    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_error
    JSR     lcd_strcpy
    JSR     lcd_update
    JSR     tape_remote_output_low

.tape_verify_wait_for_input_loop:
    JSR     input_read_front_panel
    TSTB
    BEQ     .tape_verify_wait_for_input_loop

    JMP     tape_verify


; =============================================================================
; TAPE_INPUT_ALL
; =============================================================================
; DESCRIPTION:
; Reads all 20 patches from the cassette interface.
;
; =============================================================================
tape_input_all:                                 SUBROUTINE
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_dest
    LDX     #str_from_tape_to_mem
    JSR     lcd_strcpy
    JSR     lcd_update

; Read front-panel input to determine the next action.
; If 'No' is pressed, the tape UI actions are aborted.
; If 'Yes' is pressed, the operation proceeeds.
; If the 'Remote' button is pressed, toggle the remote output polarity,
; and loop back to wait for further input.
.tape_input_all_is_remote_button_pressed:
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_10
    BEQ     .tape_input_all_remote_button_pressed

    CMPB    #INPUT_BUTTON_NO
    BEQ     .tape_input_all_no_button_pressed

    BRA     .tape_input_all_is_yes_button_pressed

.tape_input_all_no_button_pressed:
    JMP     .tape_input_all_aborted

.tape_input_all_is_yes_button_pressed:
    CMPB    #INPUT_BUTTON_YES
; If the 'Yes' button has not been pressed by this point, loop back to
; await user input.
    BNE     .tape_input_all_is_remote_button_pressed

    LDAA    memory_protect
    TSTA
    BNE     .tape_input_all_exit_memory_protected

; Initialise the verification process.
; Clear a space in the LCD buffer with 0x14 (@TODO: Verify?)
; Pull the tape remote output high, clear the tape function abort flag, and
; clear the verify patch index.
    LDX     #(lcd_buffer_next + 26)
    LDAA    #$14
    LDAB    #6
.tape_input_all_clear_lcd_loop:
    STAA    0,x
    INX
    DECB
    BNE     .tape_input_all_clear_lcd_loop

    JSR     lcd_update
    JSR     tape_remote_output_high

    CLR     tape_function_aborted_flag

    CLRA
    STAA    tape_patch_index

.tape_input_all_patches_loop:
; Print the incoming patch number.
    LDX     #(lcd_buffer_next + 29)
    STX     <memcpy_ptr_dest
    INCA
    JSR     lcd_print_number_three_digits
    JSR     lcd_update

; Read the patch over the cassette interface.
; If an error occurred, exit.
    JSR     tape_input_patch
    TST     tape_function_aborted_flag
    BNE     .tape_input_all_exit_cancelled_by_user

    LDAA    tape_patch_index
    CMPA    tape_patch_output_counter
    BNE     .tape_input_all_print_error_message

; Calculate the actual checksum of the received patch, compare against the
; checksum contained in the serialised patch data.
    JSR     tape_calculate_patch_checksum
    SUBD    tape_patch_checksum
    BNE     .tape_input_all_print_error_message

    LDAA    tape_patch_index
    JSR     patch_copy_from_tape_buffer
    LDAA    tape_patch_index
    INCA
    STAA    tape_patch_index
    CMPA    #20
    BNE     .tape_input_all_patches_loop

    JSR     tape_remote_output_low
    CLI
    JSR     ui_button_function_play

    LDAB    #19
    JSR     patch_load_store_edit_buffer_to_compare
    JMP     ui_print_update_led_and_menu

.tape_input_all_remote_button_pressed:
    JSR     tape_remote_toggle_output_polarity
    JMP     .tape_input_all_is_remote_button_pressed

.tape_input_all_exit_memory_protected:
    CLI

; Trigger the front-panel button press for 'Memory Protect', and exit.
    LDAB    #INPUT_BUTTON_20
    INS
    INS
    INS
    INS
    JMP     main_input_handler_dispatch

.tape_input_all_exit_cancelled_by_user:
    JSR     tape_remote_output_low
    LDAA    tape_patch_index
    BEQ     .tape_input_all_aborted

    LDAA    #20
    STAA    patch_index_current
    LDAA    #EVENT_HALT_VOICES_RELOAD_PATCH
    STAA    main_patch_event_flag
    CLI

; Set the synth's UI to 'Play' mode, and trigger the front-panel button press
; for the last received patch index.
    LDAB    #INPUT_BUTTON_PLAY
    JSR     main_input_handler_dispatch

; Adding '7' to this number converts it to a numeric button index.
; This will trigger a button-press for that patch selection.
; If this is above the maximum supported patch index, nothing should happen.
    LDAB    tape_patch_index
    ADDB    #7
    INS
    INS
    INS
    INS
    JMP     main_input_handler_dispatch

.tape_input_all_aborted:
    JSR     tape_remote_output_low
    CLI
    RTS

.tape_input_all_print_error_message:
    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_error
    JSR     lcd_strcpy
    JSR     lcd_update
    JSR     tape_remote_output_low

.tape_input_all_wait_for_input_to_retry_loop:
    JSR     input_read_front_panel
    TSTB
    BEQ     .tape_input_all_wait_for_input_to_retry_loop

    JMP     tape_input_all


; =============================================================================
; TAPE_INPUT_SINGLE
; =============================================================================
; DESCRIPTION:
; Reads a single patch over the synth's cassette interface into the
; synth's edit buffer.
; First the user needs to select which patch number to read using the
; front-panel numeric switches. Then the cassette interface 'reads' each
; incoming patch until the selected one is read.
;
; =============================================================================
tape_input_single:                              SUBROUTINE
    LDX     #lcd_buffer_next
    STX     <memcpy_ptr_dest
    LDX     #str_from_tape_to_buf
    JSR     lcd_strcpy
    JSR     lcd_update

.wait_for_patch_index_selection_loop:
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_NO
    BEQ     .tape_input_single_abort

    BRA     .tape_input_single_is_yes_pressed_before_index_selection

.tape_input_single_abort:
    JMP     .tape_input_single_aborted

.tape_input_single_is_yes_pressed_before_index_selection:
; Test whether the 'Yes' button was pressed before the patch index is selected.
    CMPB    #INPUT_BUTTON_YES
    BEQ     .tape_input_single_index_selected

    BRA     .is_valid_index_selection

.tape_input_single_index_selected:
    JMP     .deserialise_patch_and_exit_to_play_mode

.is_valid_index_selection:
; Test whether the selected patch index is valid
; If the code of the button pressed is below '8', loop.
; This ensures that a numerical button was pressed.
    SUBB    #8
    BCS     .wait_for_patch_index_selection_loop

    STAB    tape_input_selected_patch_index

.tape_input_single_print_ready_message:
    LDX     #(lcd_buffer_next + 22)
    STX     <memcpy_ptr_dest
    TBA
    INCA
    JSR     lcd_print_number_three_digits
    LDX     #str_ready
    JSR     lcd_strcpy
    JSR     lcd_update

; Read front-panel input to determine the next action.
; If 'No' is pressed, the tape UI actions are aborted.
; If 'Yes' is pressed, the operation proceeeds.
; If the 'Remote' button is pressed, toggle the remote output polarity,
; and loop back to wait for further input.
.tape_input_single_is_remote_button_pressed:
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_10
    BEQ     .tape_input_single_remote_button_pressed

    BRA     .tape_input_single_is_no_button_pressed

.tape_input_single_remote_button_pressed:
    JMP     .tape_input_single_toggle_remote_polarity

.tape_input_single_is_no_button_pressed:
    CMPB    #INPUT_BUTTON_NO
    BEQ     .tape_input_single_no_button_pressed

    BRA     .tape_input_single_is_yes_button_pressed

.tape_input_single_no_button_pressed:
    JMP     .tape_input_single_aborted

.tape_input_single_is_yes_button_pressed:
    CMPB    #INPUT_BUTTON_YES
    BNE     .tape_input_single_is_remote_button_pressed

; Initialise the verification process.
; Clear a space in the LCD buffer with 0x14 (@TODO: Verify?)
; Pull the tape remote output high, clear the tape function abort flag, and
; clear the verify patch index.
    LDX     #(lcd_buffer_next + 26)
    LDAA    #$14
    LDAB    #6
.tape_input_single_clear_lcd_loop:
    STAA    0,x
    INX
    DECB
    BNE     .tape_input_single_clear_lcd_loop

    JSR     lcd_update
    JSR     tape_remote_output_high
    CLR     tape_function_aborted_flag

.input_patch_loop:
    JSR     tape_input_patch
    TST     tape_function_aborted_flag
    BNE     .tape_input_single_aborted

    JSR     tape_calculate_patch_checksum
    SUBD    tape_patch_checksum
    BEQ     .checksum_valid

; If the checksum is incorrect, print the error message and loop back.
    LDX     #(lcd_buffer_next + 29)
    STX     <memcpy_ptr_dest
    LDX     #str_err
    JSR     lcd_strcpy
    JSR     lcd_update
    BRA     .input_patch_loop

.checksum_valid:
    LDX     #(lcd_buffer_next + 29)
    STX     <memcpy_ptr_dest

; Print the incoming patch number.
    LDAA    tape_patch_output_counter
    INCA
    JSR     lcd_print_number_three_digits
    JSR     lcd_update

; Test whether the incoming patch is the 'selected' patch.
    LDAA    tape_input_selected_patch_index
    CMPA    tape_patch_output_counter
    BEQ     .set_tape_remote_output_low

; Test whether the selected patch has been missed, if so an error has occurred.
; This will exit the loop in the case that the patch is never found, once the
; 'patch_tape_counter' counter variable reaches a value over the maximum index.
    LDAA    tape_patch_output_counter
    CMPA    tape_input_selected_patch_index
    BCS     .input_patch_loop

    BRA     .print_patch_missed_error_string

.set_tape_remote_output_low:
    JSR     tape_remote_output_low

.deserialise_patch_and_exit_to_play_mode:
    LDX     #patch_buffer_tape_temp
    STX     <memcpy_ptr_src
    LDX     #patch_buffer_edit
    JSR     patch_deserialise
    LDAA    #20
    STAA    patch_index_current
    CLR     patch_current_modified_flag
    CLR     patch_compare_mode_active

; Trigger the 'Play' button press, and reload patch.
    LDAB    #INPUT_BUTTON_PLAY
    JSR     main_input_handler_process_button
    LDAA    #EVENT_HALT_VOICES_RELOAD_PATCH
    STAA    main_patch_event_flag
    CLI
    JSR     midi_sysex_tx_tape_incoming_single_patch
    RTS

.tape_input_single_aborted:
    JSR     tape_remote_output_low
    CLI
    RTS

.tape_input_single_toggle_remote_polarity:
    JSR     tape_remote_toggle_output_polarity
    JMP     .tape_input_single_is_remote_button_pressed

.print_patch_missed_error_string:
    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_error
    JSR     lcd_strcpy
    JSR     lcd_update
    JSR     tape_remote_output_low

.tape_input_single_wait_for_input_to_retry_loop:
    JSR     input_read_front_panel
    TSTB
    BEQ     .tape_input_single_wait_for_input_to_retry_loop

    LDX     #lcd_buffer_next_line_2
    STX     <memcpy_ptr_dest
    LDX     #str_single
    JSR     lcd_strcpy
    LDAB    tape_input_selected_patch_index
    JMP     .tape_input_single_print_ready_message

str_from_mem_to_tape:                   DC "from MEM to TAPEall       ready?", 0
str_verify_tape_ready:                  DC "VERIFY      TAPE          ready?", 0
str_ok:                                 DC "OK!", 0
str_error:                              DC "ERROR!", 0
str_from_tape_to_mem:                   DC "from TAPE to MEMall       ready?", 0
str_from_tape_to_buf:                   DC "from TAPE to BUFsingle  ? (1-20)", 0
str_ready:                              DC " ready?", 0
str_err:                                DC "ERR", 0
str_single:                             DC "single", 0
str_function_control_verify:            DC "FUNCTION CONTROLVERIFY COMPLETED", 0

; =============================================================================
; This appears to be some kind of symbol table left over from the ROM's
; development.
; Some more information about these remnants can be found here:
; https://ajxs.me/blog/Hacking_the_Yamaha_DX9_To_Turn_It_Into_a_DX7.html#leftover_data
; =============================================================================
    DC "CASS  "
    DC.W $E310
    DC 0, "`CASS1 "
    DC.W $E319
    DC 0, "`CASS2 "
    DC.W $E329
    DC 0, "`CDATA "
    DC.W $AE
    DC 0, "`CDATA2"
    DC.W $DD50
    DC 0, "`CERR$ "
    DC.W $C7A3
    DC 0, "`CFLASH"
    DC.W $1601
    DC 0, "`CHCNT "
    DC.W $BF
    DC 0, "`CHECK "
    DC.W $E100
    DC 0, "`CHECK1"
    DC.W $E106
    DC 0, "`CHECK2"
    DC.W $E10C
    DC 0, "`CHKSUM"
    DC.W $C000
    DC 0, "`CHKT00"
    DC.W $E17E
    DC 0, "`CHKT01"
    DC.W $E17F
    DC 0, "`CHKT02"
    DC.W $E181
    DC 0, "`CHKT1 "
    DC.W $E182
    DC 0, "`CHKT2 "
    DC.W $E18C
    DC 0, "`CHKTST"
    DC.W $E176
    DC 0, "`CHNO  "
    DC.W $A9
    DC 0, "`CKDATA"
    DC.W $DD41
    DC 0, "`CMP1  "
    DC.W $DE89
    DC 0, "`CMP2  "
    DC.W $DE9B
    DC 0, "`CMP3  "
    DC.W $DE9E
    DC 0, "`CMPFLG"
    DC.W $15FA
    DC 0, "`CNGTL1"
    DC.W $D343
    DC 0, "`CNGTL2"
    DC.W $D353


; =============================================================================
; MIDI_INIT
; =============================================================================
; LOCATION: 0xEF80
;
; DESCRIPTION:
; Initialises the synth's MIDI subsystem.
;
; =============================================================================
midi_init:                                      SUBROUTINE
; Set the data format, and clock source for the serial interface.
    LDAA    #(RATE_MODE_CTRL_CC0 | RATE_MODE_CTRL_CC1)
    STAA    <rate_mode_ctrl

    LDAA    #(SCI_CTRL_TE | SCI_CTRL_RE | SCI_CTRL_RIE | SCI_CTRL_TDRE)
    STAA    <sci_ctrl_status

; Reading STATUS, then reading RECEIVE will clear Status[RDRF].
    LDAA    <sci_ctrl_status
    LDAA    <sci_rx

; Initialise the synth's MIDI transmit ring buffer.
; This is done by pointing both the read, and write buffer pointers to the
; start of the TX data buffer.
    LDX     #midi_buffer_tx
    STX     <midi_buffer_ptr_tx_write
    STX     <midi_buffer_ptr_tx_read

; Set the last received MIDI status to that of a 'SYSEX End' message.
; This will cause a no-operation in the main executive loop's MIDI
; processing function.
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received

; Initialise the synth's MIDI receive ring buffer.
    LDX     #midi_buffer_rx
    STX     <midi_buffer_ptr_rx_write
    STX     <midi_buffer_ptr_rx_read
    RTS


; =============================================================================
; MIDI_RESET
; =============================================================================
; LOCATION: 0xEF9F
;
; DESCRIPTION:
; This subroutine halts all voices, and resets all MIDI buffers, and variables.
; This is called in the case of any hardware MIDI interface errors.
;
; =============================================================================
midi_reset:                                     SUBROUTINE
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count
    LDAA    #MIDI_STATUS_SYSEX_END
    STAA    <midi_last_command_received
    LDX     #midi_buffer_rx
    STX     <midi_buffer_ptr_rx_write
    STX     <midi_buffer_ptr_rx_read
    RTS


; =============================================================================
; MIDI_TX_NOTE_ON
; =============================================================================
; LOCATION: 0xEFB4
;
; DESCRIPTION:
; Sends a 'Note On' MIDI event.
; The DX9 has a fixed output velocity of 64.
;
; ARGUMENTS:
; Registers:
; * ACCB: The MIDI note number to send with the 'Note On' event.
;
; =============================================================================
midi_tx_note_on:                                SUBROUTINE
    LDAA    #MIDI_STATUS_NOTE_ON
    JSR     midi_tx
    TBA
    JSR     midi_tx

; Fixed output MIDI velocity.
    LDAA    #64
    JSR     midi_tx
    RTS


; =============================================================================
; MIDI_TX_NOTE_OFF
; =============================================================================
; LOCATION: 0xEFC3
;
; DESCRIPTION:
; Sends a 'Note Off' MIDI event.
; The DX9 creates a 'Note Off' MIDI event by sending a 'Note On' event with
; zero velocity.
;
; ARGUMENTS:
; Registers:
; * ACCB: The MIDI note number to send with the 'Note Off' event.
;
; =============================================================================
midi_tx_note_off:                               SUBROUTINE
    LDAA    #MIDI_STATUS_NOTE_ON
    JSR     midi_tx
    TBA
    JSR     midi_tx
    CLRA
    JSR     midi_tx
    RTS


; =============================================================================
; MIDI_TX
; =============================================================================
; LOCATION: 0xEFD1
;
; DESCRIPTION:
; Pushes a MIDI message byte to the MIDI TX ring buffer, and sets the TIE
; flag in the 'SCI Control Status' register. This will cause a TDRE interrupt
; to be generated, which will send the MIDI message in the next SCI TDRE IRQ.
; This happens in the 'handler_sci' SCI interrupt handler routine.
;
; ARGUMENTS:
; Registers:
; * ACCA: The MIDI message byte to enqueue.
;
; =============================================================================
midi_tx:                                        SUBROUTINE
    LDX     <midi_buffer_ptr_tx_write
    STAA    0,x

; Check whether the MIDI TX write buffer has reached the last address within
; the MIDI TX buffer.
    CPX     #midi_buffer_tx_end - 1
; If the ring buffer hasn't reached the last address, branch.
    BNE     .increment_buffer_ptr

; If the pointer pointed to the last address in the TX buffer, load the last
; address BEFORE the TX buffer, prior to the pointer being incremented and
; stored.
    LDX     #midi_buffer_tx - 1

.increment_buffer_ptr:
    INX
    CPX     <midi_buffer_ptr_tx_read
    BEQ     midi_tx

    STX     <midi_buffer_ptr_tx_write

; Enable TX, RX, TX interrupts, and RX interrupts.
    LDAA    #(SCI_CTRL_TE | SCI_CTRL_TIE | SCI_CTRL_RE | SCI_CTRL_RIE | SCI_CTRL_TDRE)
    STAA    <sci_ctrl_status

    RTS


; =============================================================================
; MIDI_TX_ANALOG_INPUT_EVENT
; =============================================================================
; LOCATION: 0xEFE9
;
; DESCRIPTION:
; Transmits an analog input event, such as a portamento, or sustain pedal
; status change, as a MIDI 'Mode Change' MIDI event.
; This subroutine sends the argument in ACCB, then ACCA shifted once to the
; right. This is done since the value must be 7-bits to be a MIDI data message.
;
; ARGUMENTS:
; Registers:
; * ACCA: The 'value' of the mode change event.
; * ACCB: Type 'type' of the 'Mode Change' event.
;
; =============================================================================
midi_tx_analog_input_event:                     SUBROUTINE
    PSHA
    LDAA    #MIDI_STATUS_MODE_CHANGE
    JSR     midi_tx
    TBA
    JSR     midi_tx
    PULA
    LSRA
    JSR     midi_tx
    RTS


; =============================================================================
; MIDI_TX_PEDAL_STATUS_SUSTAIN
; =============================================================================
; LOCATION: 0xEFF9
;
; DESCRIPTION:
; Sends a MIDI 'Mode Change' event corresponding to the sustain pedal status.
; Sends either a 0, or 0xFF value, depending on whether the pedal status is
; off, or on.
;
; =============================================================================
midi_tx_pedal_status_sustain:                   SUBROUTINE
    LDAB    #64
    CLRA
    TIMD    #PEDAL_INPUT_SUSTAIN, pedal_status_current
; Falls-through below.

; =============================================================================
; MIDI_TX_ANALOG_INPUT_SUSTAIN_PORTA
; =============================================================================
; DESCRIPTION:
; Sends a MIDI message corresponding to portamento, and sustain analog inputs.
;
; ARGUMENTS:
; Registers:
; * CC:C: Whether the analog input event was 'On', or 'Off'.
;
; =============================================================================
midi_tx_analog_input_sustain_porta:             SUBROUTINE
    BEQ     .send_sustain_porta_value

    COMA

.send_sustain_porta_value:
    BSR     midi_tx_analog_input_event
    RTS


; =============================================================================
; MIDI_TX_PEDAL_STATUS_PORTAMENTO
; =============================================================================
; LOCATION: 0xF005
;
; DESCRIPTION:
; Sends a MIDI 'Mode Change' event corresponding to the portamento pedal
; status. Sends either a 0, or 0xFF value, depending on whether the pedal
; status is off, or on.
;
; =============================================================================
midi_tx_pedal_status_portamento:                SUBROUTINE
    LDAB    #65
    CLRA
    TIMD    #PEDAL_INPUT_PORTA, pedal_status_current
    BRA     midi_tx_analog_input_sustain_porta


; =============================================================================
; MIDI_TX_CC_INCREMENT_DECREMENT
; =============================================================================
; LOCATION: 0xF00D
;
; DESCRIPTION:
; Sends a MIDI control change event corresponding to the triggering of the
; yes/no front-panel buttons.
;
; ARGUMENTS:
; Registers:
; * ACCB: The triggering front-panel button. In this case, either YES(1),
;         or NO(2).
;
; =============================================================================
midi_tx_cc_increment_decrement:                 SUBROUTINE
    PSHB
    ADDB    #95
    LDAA    #$FF
    BSR     midi_tx_analog_input_event
    PULB
    RTS


; =============================================================================
; MIDI_TX_PROGRAM_CHANGE_CURRENT_PATCH
; =============================================================================
; LOCATION: 0xF016
;
; DESCRIPTION:
; If SysEx is enabled, this subroutine sends a MIDI 'Program Change' event
; with the currently selected patch index.
; This subroutine is initiated from a front-panel key press.
;
; =============================================================================
midi_tx_program_change_current_patch:           SUBROUTINE
    TST     sys_info_avail
    BNE     .exit

    LDAA    #MIDI_STATUS_PROGRAM_CHANGE
    JSR     midi_tx

    LDAA    patch_index_current
    ANDA    #$7F
    JSR     midi_tx

.exit:
    RTS


; =============================================================================
; MIDI_TX_PITCH_BEND_EVENT
; =============================================================================
; LOCATION: 0xF029
;
; DESCRIPTION:
; Sends a MIDI event corresponding to an update from the front-panel
; pitch-bend wheel.
; This will send a 14-bit value over the selected MIDI channel, sent as
; three bytes, the status byte, and two data bytes.
; Refer to this resource for more information on the structure of a
; MIDI pitch-bend event:
; https://sites.uci.edu/camp2014/2014/04/30/managing-midi-pitchbend-messages/
;
; (from the above site) "If we bit-shift 95 to the left by 7 bits we
; get 12,160, and if we then combine that with the LSB value 120 by a
; bitwise OR or by addition, we get 12,280."
;
; ARGUMENTS:
; Registers:
; * ACCA: The pitch-bend value received from the hardware input scanner.
;
; =============================================================================
midi_tx_pitch_bend:                             SUBROUTINE
    TAB
    LDAA    #MIDI_STATUS_PITCH_BEND
    JSR     midi_tx
    TBA

; If this value is positive, indicating that the value is a downward bend,
; clear the MSB of the two-byte MIDI data message.
    BPL     .pitch_bend_downwards

    ANDA    #%1111111
    BRA     .send_pitch_bend_event

.pitch_bend_downwards:
    CLRA

.send_pitch_bend_event:
    JSR     midi_tx
    TBA
    LSRA
    JSR     midi_tx

    RTS


; =============================================================================
; MIDI_SYSEX_TX_PARAM_CHANGE
; =============================================================================
; DESCRIPTION:
; Sends a SysEx parameter change event.
; This subroutine will determine the proper parameter change message format to
; send based upon the parameter address in the IX register.
;
; ARGUMENTS:
; Registers:
; * IX:   The address of the selected parameter to send via SysEx.
;
; Memory:
; * ui_active_param_address: The address of the currently selected parameter.
;
; =============================================================================
midi_sysex_tx_param_change:                     SUBROUTINE
; If SysEx transmission is not enabled, exit.
    TST     sys_info_avail
    BEQ     .exit

; If the currently selected parameter is not editable, exit.
    CPX     #null_edit_parameter
    BEQ     .exit

; Test if the currently selected edit parameter is a function parameter.
; If so it will be above the 'master tune' parameter in memory.
    CPX     #master_tune
    BCC     .is_parameter_invalid_high

; If the patch compare mode is active, exit.
    TST     patch_compare_mode_active
    BNE     .exit

; If the currently selected edit parameter is the 'key transpose' parameter,
; handle this differently.
    CPX     #patch_edit_key_transpose
    BNE     .send_sysex_header

    JMP     midi_sysex_tx_key_transpose_send

.send_sysex_header:
    LDAA    #MIDI_STATUS_SYSEX_START
    JSR     midi_tx
    LDAA    #MIDI_MANUFACTURER_ID_YAMAHA
    JSR     midi_tx
    LDAA    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    JSR     midi_tx
; Load the currently selected edit parameter address, and subtract the
; edit buffer address to get the relative offset of the parameter in ACCB.
    LDD     ui_active_param_address
    SUBD    #patch_buffer_edit

    LDX     #table_midi_sysex_dx7_translation
    ABX
    CLRA
    LDAB    0,x

; Test whether the parameter is above 128. If so, set bit 1 of the second
; MIDI byte, since MIDI can only send 7-bit values.
    SUBB    #128
    BCS     .parameter_offset_over_128

    INCA
    BRA     .send_parameter_data

.parameter_offset_over_128:
; Re-add the subtracted 128.
    ADDB    #128
    BRA     .send_parameter_data

.is_parameter_invalid_high:
; Test whether the currently selected edit parameter pointer points to
; something higher in memory than the MIDI RX channel. If so, it represents
; an invalid value. In this case, exit.
    CPX     #midi_rx_channel
    BCC     .exit

    LDAA    #MIDI_STATUS_SYSEX_START
    JSR     midi_tx
    LDAA    #MIDI_MANUFACTURER_ID_YAMAHA
    JSR     midi_tx
    LDAA    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    JSR     midi_tx

; Get the function parameter number by loading the address of the parameter
; from the pointer, then subtracting the 'master_tune' address.
    LDD     ui_active_param_address
    SUBD    #master_tune

; @TODO: Why does this not match DX7?
    LDAA    #12
    ADDB    #65

.send_parameter_data:
    JSR     midi_tx
    TBA
    ANDA    #$7F
    JSR     midi_tx
    LDX     ui_active_param_address
    LDAA    0,x
    JSR     midi_sysex_tx_param_change_algorithm_check
    ANDA    #$7F
    JSR     midi_tx

.exit:
    RTS

; =============================================================================
; This table translates the edit buffer parameter addresses to the equivalent
; offsets in the DX7 patch edit buffer.
; =============================================================================
table_midi_sysex_dx7_translation:
    DC.B 0, 1, 2, 3, 4, 5, 6
    DC.B 7, $A, $D, $E, $10, $12
    DC.B $13, $14, $15, $16, $17
    DC.B $18, $19, $1A, $1B, $1C
    DC.B $1F, $22, $23, $25, $27
    DC.B $28, $29, $2A, $2B, $2C
    DC.B $2D, $2E, $2F, $30, $31
    DC.B $34, $37, $38, $3A, $3C
    DC.B $3D, $3E, $3F, $40, $41
    DC.B $42, $43, $44, $45, $46
    DC.B $49, $4C, $4D, $4F, $51
    DC.B $52, $53, $86, $87, $88
    DC.B $89, $8A, $8B, $8C, $8E
    DC.B $8F, $90


; =============================================================================
; MIDI_TX_SYSEX_PARAM_CHANGE_ALGORITHM_CHECK
; =============================================================================
; LOCATION: 0xF0FE
;
; DESCRIPTION:
; If the currently selected parameter being transmitted via SysEx is the
; current patch's algorithm, this subroutine converts it to the equivalent
; algorithm number used by the DX7.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the currently 'selected' parameter being transmitted
;         within patch memory.
; * ACCA: The value of the currently 'selected' parameter being trasmitted.
;
; RETURNS:
; * ACCA: The converted algorithm value, if updated.
;
; =============================================================================
midi_sysex_tx_param_change_algorithm_check:     SUBROUTINE
    CPX     #patch_edit_algorithm
    BNE     .exit

    LDX     #table_algorithm_conversion
    TAB
    ABX
    LDAA    0,x

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_PARAM_CHANGE_OPERATOR_ENABLE
; =============================================================================
; DESCRIPTION:
; Combines the status of each of the synth's operators into a single value,
; and then sends it via SysEx.
;
; =============================================================================
midi_sysex_tx_param_change_operator_enable:     SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

    LDAA    #MIDI_STATUS_SYSEX_START
    JSR     midi_tx
    LDAA    #MIDI_MANUFACTURER_ID_YAMAHA
    JSR     midi_tx
    LDAA    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    JSR     midi_tx
    LDAA    #1
    JSR     midi_tx
    LDAA    #27
    JSR     midi_tx

; Create a bitmask of the operator enabled status by setting/clearing the
; carry-bit accordingly, and 'rotating' the carry bit into ACCA to create the
; final bitmasked value.
    LDX     #operator_4_enabled_status
    CLRA
.create_operator_bitmask_loop:
    CLC
    TST     0,x
    BEQ     .operator_disabled

    SEC

.operator_disabled:
    ROLA
    INX
    CPX     #ui_mode_memory_protect_state
    BNE     .create_operator_bitmask_loop

    JSR     midi_tx

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_KEY_TRANSPOSE
; =============================================================================
; LOCATION: 0xF13E
;
; DESCRIPTION:
; Transmits the synth's key transpose settings via SysEx.
;
; =============================================================================
midi_sysex_tx_key_transpose:                    SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

midi_sysex_tx_key_transpose_send:
    LDAA    #MIDI_STATUS_SYSEX_START
    JSR     midi_tx
    LDAA    #MIDI_MANUFACTURER_ID_YAMAHA
    JSR     midi_tx
    LDAA    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    JSR     midi_tx
    LDAA    #1
    JSR     midi_tx
    LDAA    #MIDI_SYSEX_SUBSTATUS_PARAM_CHANGE
    JSR     midi_tx
    LDAA    patch_edit_key_transpose
    ADDA    #12
    ANDA    #%1111111
    JSR     midi_tx

.exit:
    RTS


; =============================================================================
; MIDI_TX_ACTIVE_SENSING
; =============================================================================
; DESCRIPTION:
; Sends an 'Active Sensing' event via the MIDI interface.
; Note that this implementation predates the final MIDI specification.
;
; =============================================================================
midi_tx_active_sensing:                         SUBROUTINE
    LDAA    #MIDI_STATUS_SYSEX_START
    JSR     midi_tx
    LDAA    #MIDI_MANUFACTURER_ID_YAMAHA
    JSR     midi_tx
    RTS


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_SINGLE_PATCH
; =============================================================================
; DESCRIPTION:
; Transmits a single patch bulk data dump over SysEx.
;
; ARGUMENTS:
; Memory:
; * patch_index_current: The 0-indexed number of the patch to send.
;
; =============================================================================
midi_sysex_tx_bulk_data_single_patch:           SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

    LDAA    patch_index_current
    BMI     .exit

    STAA    <midi_sysex_patch_number
    JSR     midi_sysex_tx_bulk_data_serialise_bulk_from_index
    JSR     midi_sysex_rx_bulk_data_single_deserialise
    JSR     midi_sysex_tx_bulk_data_single_patch_send

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_TAPE_INCOMING_SINGLE_PATCH
; =============================================================================
; DESCRIPTION:
; Sends the latest patch received via the cassette interface.
;
; =============================================================================
midi_sysex_tx_tape_incoming_single_patch:       SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

    CLR     midi_sysex_patch_number
    LDX     #patch_buffer_tape_temp
    STX     <memcpy_ptr_src
    JSR     midi_sysex_tx_bulk_data_serialise_bulk_from_src_pointer
    LDAA    #'0
    STAA    midi_buffer_sysex_tx_bulk + 123
    JSR     midi_sysex_rx_bulk_data_single_deserialise
    JSR     midi_sysex_tx_bulk_data_single_patch_send

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_RECALLED_PATCH
; =============================================================================
; DESCRIPTION:
; Sends the contents of the patch compare buffer via SysEx.
;
; =============================================================================
midi_sysex_tx_recalled_patch:                   SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

; Test whether the current patch index refers to the 'Init Voice'.
    LDAA    patch_index_current
    BMI     .clear_sysex_patch_number

    CMPA    #20
    BEQ     .clear_sysex_patch_number

    STAA    <midi_sysex_patch_number
    BRA     .serialise_patch

.clear_sysex_patch_number:
    CLR     midi_sysex_patch_number

.serialise_patch:
    LDX     #patch_buffer_compare
    STX     <memcpy_ptr_src
    JSR     midi_sysex_tx_bulk_data_serialise_bulk_from_src_pointer

; If the current patch being recalled is the 'Init Voice' patch, clear the
; digits in the dummy patch name.
    LDAA    patch_index_current
    BMI     .clear_patch_number_digits

; If the current patch being recalled is the incoming patch buffer contents,
; clear the digits in the dummy patch name.
    CMPA    #20
    BEQ     .clear_second_patch_number_digit

    BRA     .set_patch_number_as_edited

.clear_patch_number_digits:
    LDAA    #'0
    STAA    midi_buffer_sysex_tx_bulk + 122

.clear_second_patch_number_digit:
    LDAA    #'0
    STAA    midi_buffer_sysex_tx_bulk + 123

.set_patch_number_as_edited:
    LDAA    #'E
    LDAB    #'D
    STD     midi_buffer_sysex_tx_bulk + 124
    JSR     midi_sysex_rx_bulk_data_single_deserialise
    JSR     midi_sysex_tx_bulk_data_single_patch_send

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_SEND_INIT_VOICE
; =============================================================================
; DESCRIPTION:
; Sends the initialise voice buffer via SysEx.
;
; =============================================================================
midi_sysex_tx_bulk_data_send_init_voice:        SUBROUTINE
    TST     sys_info_avail
    BEQ     .exit

    CLR     midi_sysex_patch_number
    LDX     #patch_buffer_init_voice
    STX     <memcpy_ptr_src
    JSR     midi_sysex_tx_bulk_data_serialise_bulk_from_src_pointer

; Print a dummy patch name to the outgoing SysEx patch buffer.
    LDX     #(midi_buffer_sysex_tx_bulk + 122)
    STX     <memcpy_ptr_dest
    CLRA
    LDAB    #$FF
    JSR     lcd_print_number_two_digits

    JSR     midi_sysex_rx_bulk_data_single_deserialise
    JSR     midi_sysex_tx_bulk_data_single_patch_send

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_ALL_PATCHES
; =============================================================================
; DESCRIPTION:
; Sends a bulk patch dump of all the synth's patches.
; @NOTE: In order for a bulk patch dump to be properly recognised, it needs to
; have a full 32 patches included. The DX9 firmware accomplishes this by
; sending whatever was in the 'incoming' buffer multiple times to pad the dump.
;
; =============================================================================
midi_sysex_tx_bulk_data_all_patches:            SUBROUTINE
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count
    JSR     lcd_clear
    JSR     lcd_update
    JSR     midi_tx_sysex_bulk_data_all_patches_header
    CLR     midi_sysex_patch_number

.send_patch_loop:
    JSR     midi_sysex_tx_bulk_data_serialise_bulk_from_index
    JSR     midi_tx_sysex_bulk_data
    LDAB    <midi_sysex_patch_number
    INCB
    STAB    <midi_sysex_patch_number
    CMPB    #32
    BNE     .send_patch_loop

    JSR     midi_tx_sysex_send_checksum
    JSR     ui_print

    RTS


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_SINGLE_PATCH_SEND
; =============================================================================
; DESCRIPTION:
; Sends a single patch via SysEx.
;
; =============================================================================
midi_sysex_tx_bulk_data_single_patch_send:      SUBROUTINE
    CLRB
.send_sysex_header_loop:
    LDX     #midi_sysex_header_bulk_data_single
    ABX
    LDAA    0,x
    JSR     midi_tx
    INCB
    CMPB    #6
    BCS     .send_sysex_header_loop

    CLR     midi_sysex_tx_checksum
    LDX     #midi_buffer_sysex_tx_single

.send_patch_data_loop:
    LDAA    0,x
    PSHX
    TAB
    ADDB    <midi_sysex_tx_checksum
    STAB    <midi_sysex_tx_checksum
    ANDA    #$7F
    JSR     midi_tx
    PULX
    INX
    CPX     #midi_buffer_sysex_rx_single
    BNE     .send_patch_data_loop

; Send the patch checksum.
    NEGB
    ANDB    #$7F
    TBA
    JSR     midi_tx
    RTS

midi_sysex_header_bulk_data_single:
    DC.B MIDI_STATUS_SYSEX_START
    DC.B MIDI_MANUFACTURER_ID_YAMAHA
    DC.B 0
    DC.B 0
    DC.B 1
    DC.B $1B


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_ALL_PATCHES_HEADER
; =============================================================================
; DESCRIPTION:
; Sends a bulk patch dump of all the synth's patches.
; @NOTE: In order for a bulk patch dump to be properly recognised, it needs to
; have a full 32 patches included. This is  accomplished by sending whatever
; is in the 'incoming' buffer multiple times to pad the patch dump.
;
; =============================================================================
midi_tx_sysex_bulk_data_all_patches_header:     SUBROUTINE
    CLRB

.send_sysex_header_loop:
    LDX     #midi_sysex_header_bulk_data_all_patches
    ABX
    LDAA    0,x
    JSR     midi_tx
    INCB
    CMPB    #6
    BCS     .send_sysex_header_loop

    CLR     midi_sysex_tx_checksum
    RTS

midi_sysex_header_bulk_data_all_patches:
    DC.B MIDI_STATUS_SYSEX_START
    DC.B MIDI_MANUFACTURER_ID_YAMAHA
    DC.B 0
    DC.B 9
    DC.B $20
    DC.B 0


; =============================================================================
; MIDI_TX_SYSEX_BULK_DATA
; =============================================================================
; DESCRIPTION:
; Sends the outgoing SysEx bulk data over the MIDI interface.
;
; =============================================================================
midi_tx_sysex_bulk_data:                        SUBROUTINE
    LDX     #midi_buffer_sysex_tx_bulk

.send_bulk_sysex_data:
    LDAA    0,x
    PSHX
    TAB
    ADDB    <midi_sysex_tx_checksum
    STAB    <midi_sysex_tx_checksum
    ANDA    #$7F
    JSR     midi_tx
    PULX
    INX
    CPX     #midi_buffer_sysex_rx_bulk
    BNE     .send_bulk_sysex_data

    RTS


; =============================================================================
; MIDI_TX_SYSEX_SEND_CHECKSUM
; =============================================================================
; DESCRIPTION:
; Sends the outgoing SysEx checksum over the MIDI interface.
;
; =============================================================================
midi_tx_sysex_send_checksum:                    SUBROUTINE
    LDAA    <midi_sysex_tx_checksum
    NEGA
    ANDA    #$7F
    JSR     midi_tx

    RTS


; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_SERIALISE_BULK_FROM_INDEX
; =============================================================================
; DESCRIPTION:
; Serialises a patch from the index in the 'midi_sysex_patch_number'
; variable to the SysEx bulk data buffer.
;
; Memory:
; * midi_sysex_patch_number: The index of the patch to serialise.
;
; =============================================================================
midi_sysex_tx_bulk_data_serialise_bulk_from_index:  SUBROUTINE
; The incoming patch number could be 20.
    LDAA    <midi_sysex_patch_number
    BPL     .is_incoming_patch_number_above_20

    JMP     midi_tx_sysex_bulk_data_exit

.is_incoming_patch_number_above_20:
    CMPA    #20
    BLS     .get_offset_into_patch_buffer

    LDAA    #20

.get_offset_into_patch_buffer:
    LDAB    #64
    MUL
    ADDD    #patch_buffer
    STD     <memcpy_ptr_src
; Falls-through below.

; =============================================================================
; MIDI_SYSEX_TX_BULK_DATA_SERIALISE_BULK_FROM_SRC_POINTER
; =============================================================================
; DESCRIPTION:
; Serialises a patch from the location in 'memcpy_ptr_src' to the
; SysEx bulk data buffer.
;
; ARGUMENTS:
; Memory:
; * memcpy_ptr_src: The source pointer to the patch data.
;
; =============================================================================
midi_sysex_tx_bulk_data_serialise_bulk_from_src_pointer:    SUBROUTINE
    LDX     #midi_buffer_sysex_tx_bulk
    LDAB    #4

.serialise_operator_loop:
    PSHB
    LDAB    #8
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDAA    #$F
    CLRB
    STD     0,x
    LDX     <memcpy_ptr_src
    LDAA    0,x
    LDAB    #4
    LDX     <memcpy_ptr_dest
    STD     2,x
    LDX     <memcpy_ptr_src
    LDAA    1,x
    ANDA    #7
    LDAB    5,x
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    4,x
    LDX     <memcpy_ptr_src
    LDAA    1,x
    LSRA
    LSRA
    LSRA
    ANDA    #3
    LDX     <memcpy_ptr_dest
    STAA    5,x
    LDX     <memcpy_ptr_src
    LDD     2,x
    ASLB
    LDX     <memcpy_ptr_dest
    STD     6,x
    LDX     <memcpy_ptr_src
    LDAA    4,x
    LDX     <memcpy_ptr_dest
    STAA    8,x
    LDX     <memcpy_ptr_src
    LDAB    #6
    ABX
    STX     <memcpy_ptr_src
    LDX     <memcpy_ptr_dest
    LDAB    #9
    ABX
    PULB
    DECB
    BNE     .serialise_operator_loop

; Set up the remaining two operators.
    LDAB    #2
.create_missing_operator_data_loop:
    PSHB

    LDAB    #$C
    CLRA

.fill_operator_data_loop:
    STAA    0,x
    INX
    DECB
    BNE     .fill_operator_data_loop

; Write the detune | Rate Scale value.
; 0x38 = 7 << 3.
    LDAA    #$38
    STAA    0,x
    INX

    LDAB    #4
    CLRA

.fill_operator_data_2_loop:
    STAA    0,x
    INX
    DECB
    BNE     .fill_operator_data_2_loop

    PULB
    DECB
    BNE     .create_missing_operator_data_loop

    LDAB    #4
    LDAA    #$63

.fill_pitch_eg_rate_loop:
    STAA    0,x
    INX
    DECB
    BNE     .fill_pitch_eg_rate_loop

    LDAB    #4
    LDAA    #$32

.fill_pitch_eg_level_loop:
    STAA    0,x
    INX
    DECB
    BNE     .fill_pitch_eg_level_loop

    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src
    LDAB    0,x
    INX
    STX     <memcpy_ptr_src
    LDX     #table_algorithm_conversion
    ABX
    LDAA    0,x
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    LDAB    #5
    JSR     memcpy_store_dest_and_copy_accb_bytes
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src
    LDD     0,x
    ASLA
    ADDB    #$C
    LDX     <memcpy_ptr_dest
    STD     0,x
    INX
    INX
    STX     <memcpy_ptr_dest

; Copy the default patch name.
    LDX     #str_dx9
    JSR     lcd_strcpy
    LDAA    <midi_sysex_patch_number
    CMPB    #20
    BEQ     .clear_sysex_patch_number

    INCA
    BRA     .print_sysex_patch_number

.clear_sysex_patch_number:
    CLRA

.print_sysex_patch_number:
    CLRB
    JSR     lcd_print_number_two_digits

    LDAB    #4
    LDAA    #32
    LDX     <memcpy_ptr_dest

.clear_sysex_patch_number_lcd_space_loop:
    STAA    0,x
    INX
    DECB
    BNE     .clear_sysex_patch_number_lcd_space_loop

midi_tx_sysex_bulk_data_exit:
    RTS

str_dx9:                                DC "DX9.", 0


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_SINGLE_DESERIALISE
; =============================================================================
; DESCRIPTION:
; Deserialises a patch from the bulk SysEx patch data buffer into the single
; outgoing SysEx patch buffer.
;
; =============================================================================
midi_sysex_rx_bulk_data_single_deserialise:     SUBROUTINE
    LDAB    #6
    PSHB
    LDX     #midi_buffer_sysex_tx_bulk
    STX     <memcpy_ptr_src

    LDX     #midi_buffer_sysex_tx_single
    STX     <memcpy_ptr_dest

.deserialise_operator_loop:
    LDAB    #11
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDAA    0,x
    TAB
    ANDA    #3
    LDX     <memcpy_ptr_dest
    STAA    0,x
    LSRB
    LSRB
    ANDB    #3
    STAB    1,x
    LDX     <memcpy_ptr_src
    LDAA    1,x
    TAB
    ANDA    #7
    LDX     <memcpy_ptr_dest
    STAA    2,x
    LSRB
    LSRB
    LSRB
    ANDB    #$F
    STAB    9,x
    LDX     <memcpy_ptr_src
    LDAA    2,x
    TAB
    ANDA    #3
    LDX     <memcpy_ptr_dest
    STAA    3,x
    LSRB
    LSRB
    ANDB    #7
    STAB    4,x
    LDX     <memcpy_ptr_src
    LDAA    3,x
    LDX     <memcpy_ptr_dest
    STAA    5,x
    LDX     <memcpy_ptr_src
    LDAA    4,x
    TAB
    ANDA    #1
    LDX     <memcpy_ptr_dest
    STAA    6,x
    LSRB
    ANDB    #$1F
    LDX     <memcpy_ptr_dest
    STAB    7,x
    LDX     <memcpy_ptr_src
    LDAA    5,x
    LDX     <memcpy_ptr_dest
    STAA    8,x
    LDX     <memcpy_ptr_src
    LDAB    #6
    ABX
    STX     <memcpy_ptr_src
    LDX     <memcpy_ptr_dest
    LDAB    #$A
    ABX
    STX     <memcpy_ptr_dest
    PULB
    DECB
    BEQ     .deserialise_patch_data

    PSHB
    JMP     .deserialise_operator_loop

.deserialise_patch_data:
    LDAB    #9
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src
    TAB
    ANDA    #7
    LDX     <memcpy_ptr_dest
    STAA    0,x
    LSRB
    LSRB
    LSRB
    ANDB    #1
    STAB    1,x
    INX
    INX
    STX     <memcpy_ptr_dest
    LDAB    #4
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDAA    0,x
    INX
    STX     <memcpy_ptr_src
    TAB
    ANDA    #1
    LDX     <memcpy_ptr_dest
    STAA    0,x
    TBA
    LSRA
    ANDA    #7
    STAA    1,x
    LSRB
    LSRB
    LSRB
    LSRB
    ANDB    #7
    STAB    2,x
    INX
    INX
    INX
    STX     <memcpy_ptr_dest
    LDAB    #$B
    JSR     memcpy_store_dest_and_copy_accb_bytes

    RTS


; =============================================================================
; MIDI_PRINT_ERROR_MESSAGE
; =============================================================================
; DESCRIPTION:
; If an error condition is encountered during the processing of incoming, or
; outgoing MIDI data, the 'midi_error_code' variable will be set.
; This subroutine will print the appropriate message to the LCD, according to
; this error code.
;
; Memory:
; * midi_error_code: The error code to print.
;
; =============================================================================
midi_print_error_message:                       SUBROUTINE
    JSR     lcd_clear_line_2
    LDAA    #MIDI_ERROR_BUFFER_FULL
    CMPA    <midi_error_code
    BNE     .print_error_message_data

    LDX     #str_midi_buffer_full
    BRA     .print_error_message_print_and_exit

.print_error_message_data:
    LDX     #str_midi_data_error

.print_error_message_print_and_exit:
    JSR     lcd_strcpy
    JSR     lcd_update
    CLR     midi_error_code

    RTS

str_midi_buffer_full:                           DC "MIDI BUFFER FULL", 0
str_midi_data_error:                            DC "MIDI DATA ERROR", 0


; =============================================================================
; MIDI_SYSEX_RX_PARAM_VOICE_PROCESS
; =============================================================================
; LOCATION: 0xF495
;
; DESCRIPTION:
; Processes incoming SysEx voice parameter data.
; This subroutine is responsible for parsing, and storing the incoming data.
;
; =============================================================================
midi_sysex_rx_param_voice_process:              SUBROUTINE
; Test whether the SysEx parameter number is above 127.
; If the parameter number is above 127, the two least-significant bits in
; this message will be set.
; This 'Parameter Group' value must be '0' since this is a voice parameter
; message.
    LDAB    <midi_sysex_format_param_grp
    BNE     .parameter_above_127

; Exit in the case that 'Patch Compare Mode' is active.
    TST     patch_compare_mode_active
    BNE     .exit

    LDAB    <midi_sysex_byte_count_msb_param_number
    CMPB    #84

; Branch if the voice parameter number is '84', or above.
; DX7 parameters numbers 84 - 124 correspond to the two extra operators
; that are not present in the DX9.
    BCC     .exit

; This table acts as a translation between the DX7 voice parameter offsets,
; and those of the DX9.
; Load this translation table, and use the voice parameter number LSB as an
; index to load the offset of the corresponding parameter in voice memory.
; If the loaded offset is 0xFF, it is not valid, so exit.
    LDX     #table_sysex_voice_param_translation
    ABX
    LDAB    0,x
    BMI     .exit

; Get the offset to the selected voice parameter.
    LDX     #patch_buffer_edit
    ABX
    LDAA    <midi_sysex_byte_count_lsb_param_data
    BRA     .compare_against_current_value

.parameter_above_127:
; If this value is not '0', and not '1', it indicates that the parameter
; number must be over '255', which is invalid.
; If so, exit.
    CMPB    #1
    BNE     .exit

; Is the parameter number byte '27'?
; If so, the parameter is '155' since bit 7 is set in the parameter group
; byte.
    LDAB    <midi_sysex_byte_count_msb_param_number
    CMPB    #27
    BEQ     .parameter_is_155

; Is the parameter number above '155'?
; If so, this is invalid, exit.
    BCC     .exit

; Quite likely there is a missing branch here that exited in the case
; that 'Patch Compare Mode' is active.
    TST     patch_compare_mode_active

; This table acts as a translation between the DX7 voice parameter offsets,
; and those of the DX9.
; Load this translation table, and use the voice parameter number LSB as an
; index to load the offset of the corresponding parameter in voice memory.
; If the loaded offset is 0xFF, it is not valid, so exit.
    LDX     #table_sysex_voice_param_translation_above_127
    ABX
    LDAB    0,x
    BMI     .exit

; Get the offset to the selected voice parameter.
    LDX     #patch_buffer_edit
    ABX
    LDAA    <midi_sysex_byte_count_lsb_param_data

; Handle the case that the incoming SysEx parameter is the algorithm, or
; key transpose setting.
    JSR     midi_sysex_rx_param_set_alg_key_transpose

; If the carry bit is set at this point, it indicates an invalid value
; for the key tranpose, or algorithm settings.
    BCS     .exit

.compare_against_current_value:
; Test whether the incoming data is identical to the existing voice data.
; If not, write the data to the pointer in IX. Otherwise exit.
    CMPA    0,x
    BEQ     .exit

    STAA    0,x

; Trigger a patch reload with the newly stored voice data.
    LDAA    #EVENT_RELOAD_PATCH

; Set the patch edit buffer as having been modified.
    STAA    patch_current_modified_flag
    STAA    main_patch_event_flag
    BRA     .update_ui_and_exit

.parameter_is_155:
; Parameter '155' is the operator 'On/Off' status.
; Rotate this value left 4 times on account of having only 4 operators.
    LDAA    <midi_sysex_byte_count_lsb_param_data
    ROLA
    ROLA
    ROLA
    ROLA
    LDX     #operator_4_enabled_status

; Loop 4 times, rotating the current operator status bit into the carry bit
; each iteration.
; Clear the current operator's status in the current patch.
; If the carry bit is set, set the current operator's On/Off status
; accordingly by incrementing the byte, and then increment the pointer to
; the current patch's operator status.
.set_operator_status_loop:
    CLR     0,x
    ROLA
    BCC     .advance_set_operator_status_loop

    INC     0,x

.advance_set_operator_status_loop:
    INX
    CPX     #ui_mode_memory_protect_state
    BNE     .set_operator_status_loop

.update_ui_and_exit:
    JSR     ui_print_update_led_and_menu

.exit:
    RTS

table_sysex_voice_param_translation:
    DC.B 0, 1, 2, 3, 4, 5, 6
    DC.B 7, $FF, $FF, 8, $FF
    DC.B $FF, 9, $A, $FF, $B
    DC.B $FF, $C, $D, $E, $F
    DC.B $10, $11, $12, $13, $14
    DC.B $15, $16, $FF, $FF, $17
    DC.B $FF, $FF, $18, $19, $FF
    DC.B $1A, $FF, $1B, $1C, $1D
    DC.B $1E, $1F, $20, $21, $22
    DC.B $23, $24, $25, $FF, $FF
    DC.B $26, $FF, $FF, $27, $28
    DC.B $FF, $29, $FF, $2A, $2B
    DC.B $2C, $2D, $2E, $2F, $30
    DC.B $31, $32, $33, $34, $FF
    DC.B $FF, $35, $FF, $FF, $36
    DC.B $37, $FF, $38, $FF, $39
    DC.B $3A, $3B

table_sysex_voice_param_translation_above_127:
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $3C
    DC.B $3D
    DC.B $3E
    DC.B $3F
    DC.B $40
    DC.B $41
    DC.B $42
    DC.B $FF
    DC.B $43
    DC.B $44
    DC.B $45
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF
    DC.B $FF


; =============================================================================
; MIDI_SYSEX_RX_PARAM_SET_ALG_KEY_TRANPOSE
; =============================================================================
; LOCATION: 0xF56F
;
; DESCRIPTION:
; If the incoming SysEx parameter being set is the patch's algorithm, or
; key transpose, this subroutine will handle that.
; In any other case the subroutine will not do anything, and leave changing
; the value to the caller.
;
; ARGUMENTS:
; Registers:
; * IX:   A pointer to the DX9 voice parameter being edited.
; * ACCA: The incoming voice parameter data from the SysEx message.
;
; RETURNS:
; * ACCA: The result voice parameter data.
; The carry bit is set to indicate an error condition in the case that the
; key transpose, or algorithm value is not valid.
;
; =============================================================================
midi_sysex_rx_param_set_alg_key_transpose:      SUBROUTINE
; Test whether the voice parameter being set is the algorithm.
    CPX     #patch_edit_algorithm
    BNE     .is_sysex_param_key_transpose

; If the voice parameter currently being set is the algorithm, load the
; algorithm conversion table and iterate over it testing whether the
; incoming voice parameter data matches each particular algorithm.
    PSHX
    LDX     #table_algorithm_conversion
    CLRB

; Compare each of the DX7 algorithm numbers in the table against the
; incoming parameter value.
; If it matches, transfer the index number (which is the DX9 algorithm)
; to ACCA to return.
.find_equivalent_dx9_algorithm_loop:
    CMPA    0,x
    BEQ     .found_valid_dx9_algorithm

    INCB
    INX
    CPX     #patch_activate_lfo
    BNE     .find_equivalent_dx9_algorithm_loop

    PULX
    BRA     .exit_incoming_parameter_is_invalid

.found_valid_dx9_algorithm:
; If the correct DX9 algorithm corresponding to the incoming DX7 algorithm
; number has been found, transfer this value to ACCB, and restore the
; parameter pointer in the original IX value.
    TBA
    PULX
    BRA     .exit_incoming_parameter_is_valid

.is_sysex_param_key_transpose:
    CPX     #patch_edit_key_transpose
    BNE     .exit_incoming_parameter_is_valid

; Exit with the carry flag set in error if the 'Key Tranpose' value is
; less than '12'.
    SUBA    #12
    BCS     .exit_incoming_parameter_is_invalid

; Exit with the carry flag set in error if the 'Key Tranpose' value is
; above '24'.
; Otherwise clear the carry flag, and exit.
    CMPA    #24
    BLS     .exit_incoming_parameter_is_valid

.exit_incoming_parameter_is_invalid:
; If the incoming parameter value is invalid, set the carry flag and exit.
    SEC
    RTS

.exit_incoming_parameter_is_valid:
    CLC
    RTS


; =============================================================================
; MIDI_SYSEX_RX_PARAM_FUNCTION_64_TO_78
; =============================================================================
; LOCATION: 0xF59C
;
; DESCRIPTION:
; Handles a SysEx function parameter change message from '64' to '78'.
; These correspond to the synth's main function parameters.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx parameter number.
;
; =============================================================================
midi_sysex_rx_param_function_64_to_78:          SUBROUTINE
; If 78 or above, this is an invalid param, so branch...
    CMPA    #78
    BCC     .exit

; Load a pointer to the function data.
; Subtract '65', and use this value as an index to the specified function
; parameter in the synth's memory.
    LDX     #master_tune
    SUBA    #65
    TAB
    ABX

; Write the newly received SysEx data.
    LDAA    <midi_sysex_byte_count_lsb_param_data
    STAA    0,x

; Check whether the function parameter being edited is the polyphony.
; If so, reset the synth's voice data.
    CPX     #mono_poly
    BNE     .is_function_parameter_portamento_time

    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    CLR     active_voice_count
    BRA     .update_menu_and_exit

.is_function_parameter_portamento_time:
; If the incoming function parameter is the portamento time, re-calculate
; the portamento increment.
    CPX     #portamento_time
    BNE     .update_menu_and_exit

    JSR     portamento_calculate_rate

.update_menu_and_exit:
    JSR     ui_print_update_led_and_menu

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_RX_PARAM_FUNCTION_BUTTON
; =============================================================================
; LOCATION: 0xF5C7
;
; DESCRIPTION:
; SysEx parameter numbers below '42' correspond to DX7 button presses.
; The DX9 only acknowledges '0' to '27'.
; This subroutine initiates button presses from receiving SysEx function data.
; Refer to equivalent functionality in DX7 v1.8 firwmare at 0xEEBB.
;
; ARGUMENTS:
; Registers:
; * ACCA: The incoming SysEx parameter number.
; * ACCB: The incoming SysEx parameter data
;
; =============================================================================
midi_sysex_rx_param_function_button:            SUBROUTINE
; If the incoming parameter number is equal to 28, or above, exit.
    CMPA    #28
    BCC     .exit

; Does this message correspond to the 'Function' button?
    CMPA    #INPUT_BUTTON_FUNCTION
    BEQ     .sysex_function_button_message

; The button function parameters have two valid data states: '0', and '127'.
; '127' indicates a button being depressed.
; In this case, only acknowledge this value.
    CMPB    #127
    BNE     .exit

    BRA     .sysex_trigger_button_press

.sysex_function_button_message:
; Only respond to the function button being 'released'.
; @TODO: I'm not sure what the significance of this is. This does not
; feature in the DX7 firmware.
    TSTB
    BNE     .exit

.sysex_trigger_button_press:
; Trigger the button-press corresponding to this SysEx function parameter
; message by passing the parameter number to the main input handler.
    CLR     main_patch_event_flag
    TAB
    JSR     main_input_handler_process_button

.exit:
    RTS


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_SERIALISE_SINGLE_TO_BULK
; =============================================================================
; LOCATION: 0xF5E0
;
; DESCRIPTION:
; This subroutine serialises patch data received via the SysEx 'single'
; patch method to the bulk 'packed' format, which will later be deserialised
; into the patch edit buffer.
;
; =============================================================================
midi_sysex_rx_bulk_data_serialise_single_to_bulk:   SUBROUTINE
    LDX     #midi_buffer_sysex_rx_single
    STX     <memcpy_ptr_src
    LDX     #midi_buffer_sysex_rx_bulk
    STX     <memcpy_ptr_dest

    LDAB    #6

.serialise_operator_loop:
    PSHB

; Copy first 11 parameters.
    LDAB    #11
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDD     0,x
    ANDA    #3
    ANDB    #3
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    0,x
    LDX     <memcpy_ptr_src
    LDAA    2,x
    ANDA    #7
    LDAB    9,x
    ANDB    #$F
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    1,x
    LDX     <memcpy_ptr_src
    LDD     3,x
    ANDA    #3
    ANDB    #7
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    2,x
    LDX     <memcpy_ptr_src
    LDAA    5,x
    LDX     <memcpy_ptr_dest
    STAA    3,x
    LDX     <memcpy_ptr_src
    LDD     6,x
    ANDA    #1
    ANDB    #$1F
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    4,x
    LDX     <memcpy_ptr_src
    LDAA    8,x
    LDX     <memcpy_ptr_dest
    STAA    5,x
    LDX     <memcpy_ptr_src
    LDAB    #$A
    ABX
    STX     <memcpy_ptr_src
    LDX     <memcpy_ptr_dest
    LDAB    #6
    ABX
    STX     <memcpy_ptr_dest
    PULB
    DECB
    BNE     .serialise_operator_loop

    LDAB    #9
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDD     0,x
    INX
    INX
    STX     <memcpy_ptr_src
    ANDA    #7
    ANDB    #1
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDAB    #4
    JSR     memcpy_store_dest_and_copy_accb_bytes
    LDX     <memcpy_ptr_src
    LDD     0,x
    ANDA    #1
    ANDB    #7
    ASLB
    ABA
    LDAB    2,x
    ANDB    #7
    ASLB
    ASLB
    ASLB
    ASLB
    ABA
    INX
    INX
    INX
    STX     <memcpy_ptr_src
    LDX     <memcpy_ptr_dest
    STAA    0,x
    INX
    STX     <memcpy_ptr_dest
    LDAB    #$B
    JSR     memcpy_store_dest_and_copy_accb_bytes

    RTS


; =============================================================================
; MIDI_SYSEX_RX_BULK_DATA_DESERIALISE
; =============================================================================
; LOCATION: 0xF698
;
; DESCRIPTION:
; Deserialises, and converts a DX7 bulk packed patch (128 bytes) received via
; SysEx into the equivalent DX9 format (64 bytes).
;
; ARGUMENTS:
; Memory:
; * midi_sysex_rx_bulk_patch_index: The index in patch storage to deserialise
;    the patch into.
;
; RETURNS:
; The carry bit is set in the case of a failure in the conversion process.
;
; =============================================================================
midi_sysex_rx_bulk_data_deserialise:            SUBROUTINE
    LDX     #midi_buffer_sysex_rx_bulk
    STX     <memcpy_ptr_src
    LDAA    <midi_sysex_rx_bulk_patch_index

; Ensure patch number is less than, or equal to 20.
; @TODO: Why 20? Wouldn't a value of 20 overwrite the tape temp buffer?
    CMPA    #20
    BLS     .get_pointer_to_patch_buffer

    LDAA    #20

.get_pointer_to_patch_buffer:
; Get index into patch buffer.
    LDAB    #64
    MUL
    ADDD    #patch_buffer
    STD     <memcpy_ptr_dest

; The following section of code converts the incoming DX7 algorithm
; number into its equivalent for the DX9.
; First the incoming algorithm number is loaded into ACCA.
    LDAA    midi_buffer_sysex_rx_bulk+$6E
    CLRB

; This table acts as a translation between the DX7 voice parameter offsets,
; and those of the DX9.
; Load this translation table, and iterate over it until the specified
; DX7 algorithm is found. The index into the table will be the corresponding
; DX9 algorithm.
    LDX     #table_algorithm_conversion

.deserialise_algorithm_loop:
    CMPA    0,x
    BEQ     .store_algorithm

; Increment the pointer, and the index.
; If the end of the table is reached without the algorithm being found,
; set the carry flag and exit.
    INX
    INCB
    CMPB    #8
    BCS     .deserialise_algorithm_loop

; If the correct algorithm cannot be found, set the carry flag to
; indicate the error state, and exit.
    SEC
    BRA     .exit

; If the corresponding algorithm has been found, store this value directly
; in the incoming SysEx data buffer.

.store_algorithm:
    LDX     <memcpy_ptr_dest
    STAB    $38,x

; Deserialise each operator.
    LDAB    #4

.deserialise_operator_loop:
    PSHB

; Copy first 8 bytes (Operator EG).
    LDAB    #8
    JSR     memcpy_store_dest_and_copy_accb_bytes
    STX     <memcpy_ptr_dest
    LDX     <memcpy_ptr_src

; Load breakpoint right depth, and store.
    LDAA    2,x
    LDX     <memcpy_ptr_dest
    STAA    0,x
    LDX     <memcpy_ptr_src

; Load oscillator rate scale.
    LDAA    4,x
    ANDA    #%111

; Load amp modulation sensitivity.
    LDAB    5,x
    ANDB    #%11

; Shift and combine, then store.
    ASLB
    ASLB
    ASLB
    ABA
    LDX     <memcpy_ptr_dest
    STAA    1,x

; Load output level, and coarse frequency, then store.
    LDX     <memcpy_ptr_src
    LDD     6,x
    LSRB
    LDX     <memcpy_ptr_dest
    STD     2,x

; Load fine frequency.
    LDX     <memcpy_ptr_src
    LDAA    8,x

; Load oscillator detune.
    LDAB    4,x
    LSRB
    LSRB
    LSRB
    LDX     <memcpy_ptr_dest
    STD     4,x

; Increment the operator read pointer by 9.
    LDX     <memcpy_ptr_src
    LDAB    #9
    ABX
    STX     <memcpy_ptr_src

; Increment the operator write pointer by 6.
    LDX     <memcpy_ptr_dest
    LDAB    #6
    ABX
    PULB

; Decrement the operator index.
    DECB
    BNE     .deserialise_operator_loop

; Skip over copying the algorithm, since it has already been converted.
    INX
    STX     <memcpy_ptr_dest

; Increment read pointer by 43 bytes.
; The read pointer is now at byte 111.
    LDX     <memcpy_ptr_src
    LDAB    #43
    ABX
    STX     <memcpy_ptr_src

; Copy the next 5 bytes.
    LDX     <memcpy_ptr_dest
    LDAB    #5
    JSR     memcpy_store_dest_and_copy_accb_bytes
    STX     <memcpy_ptr_dest

; Copy LFO Pitch Mod Sensitivity, and LFO wave.
; Shift right to remove the LFO sync setting.
    LDX     <memcpy_ptr_src
    LDD     0,x
    LSRA

; Ensure the key transpose setting is between 12, and 24.
    SUBB    #12
    BCC     .is_transpose_over_24

    CLRB

.is_transpose_over_24:
    CMPB    #24
    BCS     .store_transpose_value

    LDAA    #24

.store_transpose_value:
; Store the key transpose value.
; Clear the carry bit to indicate the patch has been successfully parsed.
    LDX     <memcpy_ptr_dest
    STD     0,x
    CLC

.exit:
    RTS


; =============================================================================
; TEST_ENTRY
; =============================================================================
; LOCATION: 0xF738
;
; DESCRIPTION:
; This is the main entry point to the synth's diagnostic self-test routines.
; Once this is entered, the synth will be put in a loop, cycling through the
; diagnostic routines.
;
; =============================================================================
test_entry:                                     SUBROUTINE
    JSR     test_entry_reset_system

.test_stage_loop:
    JSR     test_entry_get_input

; Load the current test stage, and clamp this value at '12'.
; This value is then used as an index into the table of diagnostic
; function pointers.
    LDX     #table_test_function_ptrs
    LDAB    <active_voice_count
    CMPB    #12
    BCS     .jump_to_test_function

    CLRB

.jump_to_test_function:
    ASLB
    ABX
    LDX     0,x

; Jump to the test function, and then loop back to get user input again.
    JSR     0,x
    BRA     .test_stage_loop

; =============================================================================
; Test Function Pointer Table.
; =============================================================================
table_test_function_ptrs:
    DC.W test_volume
    DC.W test_lcd
    DC.W test_switch
    DC.W test_kbd
    DC.W test_adc
    DC.W test_tape
    DC.W test_tape_remote
    DC.W test_ram
    DC.W test_rom
    DC.W test_eg_op
    DC.W test_auto_scaling
    DC.W test_exit


; =============================================================================
; TEST_ENTRY_RESET_SYSTEM
; =============================================================================
; LOCATION: 0xF768
;
; DESCRIPTION:
; Resets system variables when entering the synth's self-test diagnostic mode.
; The EGS voice data will also be reset.
; This subroutine resets the test stage to '0'.
;
; =============================================================================
test_entry_reset_system:                        SUBROUTINE
    JSR     voice_reset_egs
    LDAA    #$FF
    TAP

; Disable the output-compare interrupt, and clear condition flags.
    CLRA
    STAA    <timer_ctrl_status

; Set portamento speed to instantaneous.
    LDAA    #$FF
    STAA    <portamento_rate_scaled

; @TODO
    LDD     #$100
    STD     <portamento_frequency_base

; Clear EGS pitch-mod.
    CLRA
    STAA    egs_pitch_mod_high
    STAA    egs_pitch_mod_low
    STAA    mono_poly

; Enable all operators.
    LDD     #$101
    STD     operator_4_enabled_status
    STD     operator_2_enabled_status

; Reset the button input.
    LDAA    #3
    STAA    <test_button_input

; Reset the current test stage to '0'.
    CLRB
    JSR     test_entry_store_updated_stage

    RTS


; =============================================================================
; TEST_ENTRY_GET_INPUT
; =============================================================================
; DESCRIPTION:
; Handles user input for the test mode user-interface.
; This allows the user to increment, and decrement the current 'test stage'.
;
; =============================================================================
test_entry_get_input:                           SUBROUTINE
    JSR     test_entry_get_user_input_read_buttons
    JSR     jumpoff

    DC.B test_entry_get_input_exit - *
    DC.B 1
    DC.B test_entry_get_input_increment_stage - *
    DC.B 2
    DC.B test_entry_get_input_decrement_stage - *
    DC.B 3
    DC.B test_entry_get_input_exit - *
    DC.B 0


; =============================================================================
; TEST_ENTRY_GET_INPUT_INCREMENT_STAGE
; =============================================================================
; LOCATION: 0xF7A4
;
; DESCRIPTION:
; Increment the current test stage.
; This is triggered by user input during the test entry main loop.
;
; =============================================================================
test_entry_get_input_increment_stage:           SUBROUTINE
    LDAB    <test_stage_current
    INCB
    CMPB    #12
    BCS     test_entry_store_updated_stage

    LDAB    #11
; Falls-through below.

; =============================================================================
; TEST_ENTRY_STORE_UPDATED_STAGE
; =============================================================================
; DESCRIPTION:
; Stores the newly updated test stage, and initialises variables used by the
; test stages.
; It also prints the test stage number.
;
; ARGUMENTS:
; Registers:
; * ACCB: The updated test stage to store.
;
; =============================================================================
test_entry_store_updated_stage:                 SUBROUTINE
    STAB    <test_stage_current
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data

; Reset peripherals, and sustain status.
    CLRB
    STAB    <pedal_status_current
    STAB    <sustain_status
    STAB    <pedal_status_previous

; Reset test sub-stage.
    LDAB    #$FF
    STAB    <test_stage_sub

; Print the main test stage number to the LCD screen.
; This prints 'TEST 0x'. The individual test subroutines print the test
; names starting from position 7 onwards in the LCD buffer.
    JSR     test_lcd_led_all_off
    JSR     lcd_clear
    LDX     #str_test
    JSR     lcd_strcpy

; Print the current test number to the LCD.
    LDAA    <active_voice_count
    INCA
    CLRB
    JSR     lcd_print_number_two_digits
    JSR     lcd_update

test_entry_get_input_exit:
    RTS


; =============================================================================
; TEST_ENTRY_GET_INPUT_DECREMENT_STAGE
; =============================================================================
; LOCATION: 0xF7D7
;
; DESCRIPTION:
; Decrements the current test stage.
; This is triggered by user input during the test entry main loop.
;
; MEMORY USED:
; * test_stage_current: The current test stage being changed.
;
; =============================================================================
test_entry_get_input_decrement_stage:           SUBROUTINE
    LDAB    <test_stage_current
    DECB
    BPL     .store_stage

    CLRB

.store_stage:
    BRA     test_entry_store_updated_stage

str_test:       DC "TEST", 0


; =============================================================================
; TEST_ENTRY_GET_USER_INPUT_READ_BUTTONS
; =============================================================================
; DESCRIPTION:
; Reads the front-panel button input to determine whether the 'YES', or 'NO'
; buttons are currently being pressed.
;
; RETURNS:
; * ACCB: The result of reading the front-panel button input.
;    '0' if no input, '1' if 'YES', '2' if 'NO'.
;
; =============================================================================
test_entry_get_user_input_read_buttons:         SUBROUTINE
    LDAB    <io_port_1_data
    ANDB    #%11110000
    STAB    <io_port_1_data
    DELAY_SINGLE

    LDAB    <key_switch_scan_driver_input
    ANDB    #(KEY_SWITCH_LINE_0_BUTTON_YES | KEY_SWITCH_LINE_0_BUTTON_NO)

; Load the current button input value into ACCA, and store the updated input
; into ACCB.
    LDAA    <test_button_input
    STAB    <test_button_input

; Invert the previous value, then AND this with the current updated value.
; This will set the bit of any input line that has changed.
    COMA
    ANDA    <test_button_input

; This value will be shifted right to set the carry bit in the case that a
; particular input line is set. The value '2' is loaded here since we're only
; interested in the YES/NO buttons, which are lines 0/1.
    LDAB    #2

; If the carry bit is set after rotating right once, it means the 'YES' button
; is being pressed, so return '1'.
    ASRA
    BCS     .decrement_result

; If the carry bit is set after rotating right twice, it means the 'NO' button
; is being pressed, so return '2'.
    ASRA
    BCS     .exit

; If this point has been reached, it means no buttons are being pressed.
; Decrement ACCB twice to return 0.
    DECB

.decrement_result:
    DECB

.exit:
    RTS


; =============================================================================
; TEST_LCD_LED_ALL_OFF
; =============================================================================
; DESCRIPTION:
; Turns all of the LED segments off.
;
; =============================================================================
test_lcd_led_all_off:                           SUBROUTINE
    LDAA    #$FF
; Falls-through below.

test_lcd_led_store:
    STAA    <led_1
    STAA    <led_2

    RTS


; =============================================================================
; TEST_LCD_ALL_ON
; =============================================================================
; DESCRIPTION:
; Turns all of the LED segments on.
;
; =============================================================================
test_lcd_led_all_on:                            SUBROUTINE
    CLRA
    BRA     test_lcd_led_store


; =============================================================================
; TEST_PRINT_NUMBER_TO_LED
; =============================================================================
; DESCRIPTION:
; Prints a number to the synth's LEDs. This routine is used by the keyboard,
; ADC, and switch test subroutines.
; @TODO: A number over 100 passed to this subroutine will print a pattern.
;
; =============================================================================
test_print_number_to_led:                       SUBROUTINE
    CMPA    #100
    BCC     .number_over_100

    CLRB

.count_tens_loop:
    SUBA    #10
    BCS     .test_tens_digit

    INCB
    BRA     .count_tens_loop

.test_tens_digit:
; Add '10' to the number to compensate for the final '10' subtracted.
    ADDA    #10

; Test if the number is above 10.
; If it is, proceed to looking up the tens digit.
    TSTB
    BNE     .lookup_digit_1

; If the ACCB is equal to 0, set ACCB to 0xFF to make the first digit blank.
    LDAB    #$FF
    BRA     .store_digit_1

.lookup_digit_1:
    LDX     #table_led_digit_map
    ABX
    LDAB    0,x

.store_digit_1:
    STAB    <led_1

    LDX     #table_led_digit_map
    TAB
    ABX
    LDAB    0,x
    STAB    <led_2

.exit:
    RTS

.number_over_100:
; Subtract 100 to get an index into the table.
; If the result is over 2, clear it.
    SUBA    #100
    CMPA    #2
    BCS     .lookup_table_entry

    CLRA

.lookup_table_entry:
    LDX     #table_led_patterns
    TAB
    ASLB
    ABX
    LDD     0,x
    STD     <led_1
    BRA     .exit


table_led_patterns:
    DC.W $FFFF
    DC.W $C0C0


; =============================================================================
; LCD_CLEAR_LINE_2
; =============================================================================
; LOCATION: 0xF84A
;
; DESCRIPTION:
; Clears the second line of the LCD (next) buffer.
;
; RETURNS:
; * IX: A pointer to the start of the second LCD line.
;
; =============================================================================
lcd_clear_line_2:                               SUBROUTINE
    LDAB    #16

lcd_clear_accb_chars:
    LDAA    #'

lcd_fill_accb_chars:
    LDX     #stack_bottom

.fill_chars_loop:
    DEX
    STAA    0,x
    DECB
    BNE     .fill_chars_loop

    STX     <memcpy_ptr_dest

    RTS


; =============================================================================
; LCD_CLEAR
; =============================================================================
; LOCATION: 0xF85A
;
; DESCRIPTION:
; Clears the LCD (next) buffer.
;
; MEMORY USED:
; * memcpy_ptr_dest: A pointer to the LCD buffer is stored in the copy
;    destination pointer.
;
; RETURNS:
; * IX: A pointer to the start of the LCD buffer.
;
; =============================================================================
lcd_clear:                                      SUBROUTINE
    LDAB    #32
    BRA     lcd_clear_accb_chars


; =============================================================================
; TEST_LCD_FILL
; =============================================================================
; DESCRIPTION:
; Fills the LCD display.
;
; =============================================================================
test_lcd_fill:                                  SUBROUTINE
    LDAA    #$FF
    LDAB    #32
    BRA     lcd_fill_accb_chars


; =============================================================================
; TEST_LCD_SET_WRITE_POINTER_TO_POSITION_7
; =============================================================================
; DESCRIPTION:
; Sets the LCD strcpy pointer to position 7 in the LCD buffer.
;
; =============================================================================
test_lcd_set_write_pointer_to_position_7:       SUBROUTINE
    LDD     #(lcd_buffer_next + 7)
; Falls-through below.

lcd_store_write_pointer:
    STD     <memcpy_ptr_dest
    JMP     lcd_strcpy


; =============================================================================
; TEST_LCD_SET_WRITE_POINTER_TO_LINE_2
; =============================================================================
; DESCRIPTION:
; Sets the LCD strcpy pointer to the start of line 2 in the LCD buffer.
;
; =============================================================================
test_lcd_set_write_pointer_to_line_2:           SUBROUTINE
    LDD     #lcd_buffer_next_line_2
    BRA     lcd_store_write_pointer


; =============================================================================
; TEST_KBD_PRINT_NOTE_NAME
; =============================================================================
; DESCRIPTION:
; Prints the note name, and octave to the LCD screen.
;
; ARGUMENTS:
; Registers:
; * ACCB: The note number to be printed.
;
; =============================================================================
test_kbd_print_note_name:                       SUBROUTINE
    LDX     <memcpy_ptr_dest

; Load ASCII '0'.
    LDAA    #48

.get_octave_number_loop:
; Subtract 12 from the note name with each iteration, incrementing ACCA.
; When the carry bit is set, the octave will have been found.
    INCA
    SUBB    #12
    BCC     .get_octave_number_loop

; Write the ASCII octave number to the LCD buffer.
    STAA    2,x

; Add '12' back to ACCB to compensate for the final subtraction.
    ADDB    #12

; Use the remaining number in ACCB as an index into the note name string.
    LDX     #str_note_names
    ASLB
    ABX
    LDD     0,x
    LDX     <memcpy_ptr_dest
    STD     0,x
    INX
    INX
    INX
    STX     <memcpy_ptr_dest

    RTS


; =============================================================================
; TEST_VOLUME
; =============================================================================
; DESCRIPTION:
; Resets all the synth's voice params, then plays an A4 note.
;
; =============================================================================
test_volume:                                    SUBROUTINE
; The test 'sub stage' will have been initialised as 0xFF.
    TST     test_stage_sub
    BEQ     .exit

    LDX     #str_fragment_level
    JSR     test_lcd_set_write_pointer_to_position_7
    LDX     #str_adj_vr5
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    JSR     patch_init_edit_buffer

    LDAA    #64
    STAA    master_tune
    JSR     patch_activate

; Play the 'A4' note.
    LDAB    #69
    JSR     voice_add

; Clear this flag so that the voice will only be added once.
    CLR     test_stage_sub

.exit:
    RTS

str_adj_vr5:     DC "ADJ VR5", 0


; =============================================================================
; TEST_LCD
; =============================================================================
; DESCRIPTION:
; Performs a diagnostic routine for the synth's LED, and LCD interface.
; This test will toggle the LED, and LCD display between being entirely filled,
; and being entirely cleared.
;
; =============================================================================
test_lcd:                                       SUBROUTINE
    TST     test_stage_sub
    BEQ     .test_initialised

    JSR     lcd_clear
    JSR     lcd_update
    CLR     test_stage_sub
    BRA     .exit

.test_initialised:
    LDAA    <test_stage_sub_2
    INCA
    TAB
; Toggle this flag.
    EORA    <test_stage_sub_2
    BITA    #$80
    BEQ     .store_sub_stage_and_delay

    STAB    <test_stage_sub_2
    BPL     .display_off

    JSR     test_lcd_led_all_on
    JSR     test_lcd_fill

.update_and_exit:
    JSR     lcd_update

.exit:
    RTS

.display_off:
    JSR     test_lcd_led_all_off
    JSR     lcd_clear
    BRA     .update_and_exit

.store_sub_stage_and_delay:
    STAB    <porta_current_target_frequency
    LDX     #1000

.delay_loop:
    DEX
    BNE     .delay_loop
    BRA     .exit


; =============================================================================
; TEST_SWITCH
; =============================================================================
; DESCRIPTION:
; Tests the system's front-panel switches.
;
; =============================================================================
test_switch:                                    SUBROUTINE
    LDAA    <test_stage_sub
    BEQ     .test_initialised

; The test 'sub stage' will have been initialised as 0xFF.
    CMPA    #$FF
    BEQ     .initialise_test

    JMP     .delay

.initialise_test:
    LDX     #str_sw
    JSR     test_lcd_set_write_pointer_to_position_7

    LDX     #str_push
    JSR     test_lcd_set_write_pointer_to_line_2

    CLR     test_stage_sub_2
    CLR     test_stage_sub

.test_initialised:
; If not yet 26, the test is incomplete. Proceed to the current test stage.
    LDAA    <test_stage_sub_2
    CMPA    #26
    BNE     .test_incomplete

    JMP     .test_ok

.test_incomplete:
; If the test stage is equal to, or above 26, exit.
    BCC     .exit

    LDAA    #'
    LDX     #lcd_buffer_next_end
.clear_lcd_space_loop:
    DEX
    STAA    0,x
    CPX     #(lcd_buffer_next + 21)
    BNE     .clear_lcd_space_loop

    STX     <memcpy_ptr_dest

    LDAA    <test_stage_sub_2
    CMPA    #20
    BCC     .test_stage_buttons_main

; Sub-stage 0 - 19.
; Print the numeric switches 1-20.
    LDAB    #'#
    JSR     lcd_store_character_and_increment_ptr
    CLRB
    INCA
    JSR     lcd_print_number_two_digits

.lcd_update:
    JSR     lcd_update
    BRA     .is_test_stage_pedals

.test_stage_buttons_main:
; Sub-stage 20 - 25.
; Print the 'main' button names.
    SUBA    #20
    LDX     #table_str_pointer_test_switches_stage
    TAB
    ASLB
    ABX
    LDX     0,x
    JSR     lcd_strcpy
    BRA     .lcd_update

.is_test_stage_pedals:
; Test whether the sub-stage is above 24.
; The sub-stages above 24 involve the pedals.
    LDAA    <porta_current_target_frequency
    CMPA    #24
    BCC     .test_pedals

; Read the front-panel switch state.
    JSR     input_read_front_panel
    JSR     jumpoff

    DC.B .exit - *
    DC.B 3
    DC.B .test_switch_btn_store - *
    DC.B 4
    DC.B .exit - *
    DC.B 5
    DC.B ..test_switch_btn_numeric - *
    DC.B 8
    DC.B test_switch_store_btn_numeric - *
    DC.B 0


.test_switch_btn_store:
    LDAB    #20
    BRA     .compare_against_expected_input

..test_switch_btn_numeric:
    ADDB    #16
    BRA     .compare_against_expected_input

test_switch_store_btn_numeric:
    SUBB    #8

.compare_against_expected_input:
; Compare the front-panel input state against the expected switch.
    CMPB    <porta_current_target_frequency
    BNE     .test_error

.update_expected_input:
    TBA
    INCA
    JSR     test_print_number_to_led
    LDX     #str_push
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    INC     porta_current_target_frequency
    JSR     pedals_update

.exit:
    RTS

.test_pedals:
; 24 = Test whether sustain pedal is active.
; 25 = Test portamento pedal.
    JSR     pedals_update
    CMPB    #1

; The carry being set indicates that a 0 result has been returned,
; indicating no pedal. So return and loop to wait.
    BCS     .exit

    BHI     .compare_pedal_against_expected_input

    TIMD    #PEDAL_INPUT_SUSTAIN, pedal_status_current
    BEQ     .exit

.compare_pedal_against_expected_input:
; Add 23 to the pedal state change recorded in ACCB, since the portamento pedal,
; and sustain pedal tests are test stages 24, and 25.
    ADDB    #23
    CMPB    <porta_current_target_frequency
    BNE     .test_error

    BRA     .update_expected_input

.test_ok:
    LDAA    #$FE
    STAA    <porta_current_target_frequency
    JSR     lcd_clear_line_2
    LDX     #str_ok
    JSR     lcd_strcpy
    JSR     lcd_update
    BRA     .exit

.test_error:
    TBA
    INCA
    JSR     test_print_number_to_led
    LDX     #str_test_err
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    LDAA    #$FE
    STAA    <test_stage_sub

.delay:
    LDX     #128

.delay_loop:
    JSR     delay
    DEX
    BNE     .delay_loop

    DEC     test_stage_sub
    BRA     .exit

table_str_pointer_test_switches_stage:
    DC.W str_store
    DC.W str_function
    DC.W str_edit
    DC.W str_fragment_memory
    DC.W str_sustain
    DC.W str_portamento

str_function:                           DC "FUNCTION", 0
str_edit:                               DC "EDIT", 0
str_sustain:                            DC "SUSTAIN", 0
str_portamento:                         DC.B STR_FRAGMENT_OFFSET_PORTA
                                        DC "MENTO", 0

str_push:                               DC "push", 0
str_sw:                                 DC "SW", 0
str_test_err:                           DC "ERR!", 0


; =============================================================================
; TEST_KBD
; =============================================================================
; DESCRIPTION:
; Diagnostic routine that tests whether each individual key on the keyboard is
; functioning correctly.
;
; =============================================================================
test_kbd:                                       SUBROUTINE
    LDAA    <test_stage_sub
    BEQ     .is_kbd_test_finished

    CMPA    #$FF
    BEQ     .initialise_kbd_test

    JMP     .delay_and_exit_kbd_test

.initialise_kbd_test:
    JSR     patch_init_edit_buffer
    JSR     patch_activate
    CLR     test_stage_sub_2
    LDX     #str_kbd
    JSR     test_lcd_set_write_pointer_to_position_7
    JSR     lcd_update
    CLR     test_stage_sub

.is_kbd_test_finished:
    LDAA    <test_stage_sub_2
    CMPA    #61
    BEQ     .kbd_test_finished

    BCS     .scan_for_key_down

    CMPA    #$FE
    BEQ     .scan_for_key_up

    BRA     .exit_kbd_test

.scan_for_key_down:
    JSR     keyboard_scan
    LDAB    <note_number
; Is this a key up event?
    BPL     .key_up

; Was no key pressed?
    CMPB    #$FF
    BEQ     .exit_kbd_test

; Mask the note number, and add a new voice.
    ANDB    #$7F
    JSR     voice_add

; Subtract 36 from the note number, and compare against the expected note.
    LDAB    <note_number
    ANDB    #$7F
    SUBB    #36
    CMPB    <test_stage_sub_2
    BNE     .print_kbd_test_error_message

; Print the note number to the LEDs.
    TBA
    INCA
    JSR     test_print_number_to_led
    JSR     lcd_clear_line_2
    JSR     lcd_update
    INC     test_stage_sub_2

.exit_kbd_test:
    RTS

.key_up:
    JSR     voice_remove
    BRA     .exit_kbd_test

.kbd_test_finished:
    LDAA    #$FE
    STAA    <test_stage_sub_2
    LDX     #str_ok
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    BRA     .exit_kbd_test

.scan_for_key_up:
    JSR     main_update_keyboard_and_pedal_input
    LDAB    <note_number
    BMI     .exit_kbd_test

; Remove the newly added voice from the key-press.
    JSR     voice_remove
    BRA     .exit_kbd_test

.print_kbd_test_error_message:
    TBA
    INCA
    JSR     test_print_number_to_led
    LDX     #str_test_err
    JSR     test_lcd_set_write_pointer_to_line_2
    LDX     <memcpy_ptr_dest
    INX
    STX     <memcpy_ptr_dest

    LDAB    <test_stage_sub_2
    JSR     test_kbd_print_note_name
    JSR     lcd_update

    LDAA    #$FE
    STAA    <test_stage_sub

.delay_and_exit_kbd_test:
    LDX     #$80

.delay_loop:
    JSR     delay
    DEX
    BNE     .delay_loop

    DEC     test_stage_sub
    BRA     .exit_kbd_test

str_kbd:                                DC "KBD", 0


; =============================================================================
; TEST_ADC
; =============================================================================
; DESCRIPTION:
; Tests the synth's analog input peripherals.
; This subroutine reads the analog input from the last touched peripheral, such
; as the mod wheel, pitch bend wheel, and data entry slider, and prints the
; last read value to the LED.
;
; =============================================================================
test_adc:                                       SUBROUTINE
    TST     portamento_direction
    BEQ     .continue_adc_test

    LDX     #str_ad
    JSR     test_lcd_set_write_pointer_to_position_7
    JSR     lcd_update
    CLR     portamento_direction
    BRA     .exit_adc_test

.continue_adc_test:
    LDAB    analog_input_source_next
    JSR     adc_set_source
    JSR     adc_update_input_source
    BCS     .decrement_input_source

    JSR     lcd_clear_line_2

; Get pointer to string.
; This is the next analog input source multiplied by 17, which is the length
; of each string, including the null-terminating byte.
    LDX     #str_pitch_bender
    LDAB    analog_input_source_next
    LDAA    #17
    MUL
    ABX
    JSR     test_lcd_set_write_pointer_to_line_2
    LDX     #analog_input_pitch_bend
    LDAB    analog_input_source_next
    ABX
    LDAA    0,x
    LDAB    #$64
    MUL
    JSR     test_print_number_to_led
    JSR     lcd_update

.decrement_input_source:
    LDAB    analog_input_source_next
    DECB
    BPL     .store_input_source

    LDAB    #ADC_SOURCE_SLIDER

.store_input_source:
    STAB    analog_input_source_next

.exit_adc_test:
    RTS

str_ad:                         DC "A/D", 0
str_pitch_bender:               DC "PITCH BENDER    ", 0
str_modulation_wheel:           DC "MODULATION WHEEL", 0
str_breath_controller:          DC "BREATH CONTROLER", 0
str_data_entry:                 DC "DATA ENTRY", 0


; =============================================================================
; TEST_TAPE
; =============================================================================
; DESCRIPTION:
; This test strobes the output line for an arbitrary period, then reads an
; input signal of an arbitrary frequency, testing whether the input signal's
; frequency was correctly read.
; This was potentially intended to correspond to some external test equipment.
; There is nothing contained in the synth's manual, or service manual about
; this test.
;
; =============================================================================
test_tape:                                      SUBROUTINE
; Check whether the test stage is complete.
    TST     test_stage_sub
    BEQ     .exit

; The test stage was initialised at 0xFF.
; This tests whether this test function has been initialised.
    BPL     .test_initialised

; Write test stage name to the LCD.
    LDX     #str_cassette
    JSR     test_lcd_set_write_pointer_to_position_7

    LDX     #str_push_1_button
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

; Mark the test as having been initialised.
    CLR     test_stage_sub_2
    LDAA    #1
    STAA    <test_stage_sub
    BRA     .exit

.test_initialised:
; Wait for the '1' button to be pressed to begin the actual test.
    LDAA    <test_stage_sub
    CMPA    #1
    BNE     .begin_test

    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_1
    BNE     .exit

    LDAA    #2
    STAA    <portamento_direction
    BRA     .exit

.begin_test:
    JSR     lcd_clear_line_2

; Clear ACCB so that this loop iterates 256 times.
    CLRB
.strobe_output_loop:
; Toggle the tape output line high/low.
    EIMD    #PORT_1_TAPE_OUTPUT, io_port_1_data
    BSR     test_tape_delay

; @TODO: Why is the input read?
; This does initialise the 'previous polarity', but this isn't needed?
    LDAA    <io_port_1_data
    ANDA    #PORT_1_TAPE_INPUT
    STAA    <tape_input_polarity_previous

    DECB
    BNE     .strobe_output_loop

; The following loop counts the number of pulses read over the tape input line.
    LDAB    #$80
.count_input_pulses_loop:
; Toggle the tape output line high/low.
    EIMD    #PORT_1_TAPE_OUTPUT, io_port_1_data
    BSR     test_tape_read_input

    DECB
    BNE     .count_input_pulses_loop

    LDAA    <porta_current_target_frequency

; Is the number of pulses detected less than 126?
; If so, this constitutes an error.
    CMPA    #126
    BCS     .print_error_string

; Is the number of pulses detected more than 130?
; If so, this constitutes an error.
    CMPA    #130
    BCC     .print_error_string

    LDX     #str_ok

.print_result_string:
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    CLR     portamento_direction

.exit:
    RTS

.print_error_string:
    LDX     #str_test_err
    BRA     .print_result_string


; =============================================================================
; TEST_TAPE_DELAY
; =============================================================================
; DESCRIPTION:
; An arbitrary delay used when strobing the tape interface output line.
;
; =============================================================================
test_tape_delay:                                SUBROUTINE
    LDX     #90
    NOP
    NOP

.delay_loop:
    DEX
    BNE     .delay_loop

    RTS


; =============================================================================
; TEST_TAPE_READ_INPUT
; =============================================================================
; LOCATION: 0xFBB1
;
; DESCRIPTION:
; Reads the tape input over an arbitrary period of 12 cycles, incrementing the
; test sub stage variable to count the number of 'pulses' that occur within
; the period.
;
; =============================================================================
test_tape_read_input:                           SUBROUTINE
    LDX     #12

.read_input_loop:
    LDAA    <io_port_1_data
    ANDA    #PORT_1_TAPE_INPUT
    EORA    <tape_input_polarity_previous

; Test whether the polarity has changed.
    BPL     .input_loop_delay

    EORA    <tape_input_polarity_previous
    STAA    <tape_input_polarity_previous
    INC     porta_current_target_frequency
    BRA     .advance_loop

.input_loop_delay:
    DELAY_SINGLE
    DELAY_SHORT
    DELAY_SHORT

.advance_loop:
    DEX
    BNE     .read_input_loop

    DELAY_SINGLE
    NOP

    RTS

str_cassette:                       DC "CASSETTE", 0


; =============================================================================
; TEST_TAPE_REMOTE
; =============================================================================
; DESCRIPTION:
; This test stage essentially just drives the 'remote' output line high.
;
; =============================================================================
test_tape_remote:                               SUBROUTINE
; Check whether the test has been initialised.
    TST     test_stage_sub
    BEQ     .test_initialised

; Pull the remote line low.
    AIMD    #~PORT_1_TAPE_REMOTE, io_port_1_data

; Print the test stage string.
    LDX     #str_remote
    JSR     test_lcd_set_write_pointer_to_position_7

    LDX     #str_push_1_button
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

    CLR     test_stage_sub_2

; Mark the test as complete.
    CLR     test_stage_sub
    BRA     .exit

.test_initialised:
    TST     test_stage_sub_2
    BNE     .exit

; Wait for the '1' button to be pressed.
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_1
    BNE     .exit

; Pull the remote line high.
    OIMD    #PORT_1_TAPE_REMOTE, io_port_1_data
    JSR     lcd_clear_line_2

    LDX     #str_on
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

; Mark the test as complete.
    LDAA    #$FF
    STAA    <porta_current_target_frequency

.exit:
    RTS

str_remote:                             DC "REMOTE", 0
str_on:                                 DC "ON", 0


; =============================================================================
; TEST_RAM
; =============================================================================
; DESCRIPTION:
; Tests the synth's internal RAM to diagnose any errors.
;
; =============================================================================
test_ram:                                       SUBROUTINE
    LDAB    <portamento_direction
    JSR     jumpoff

    DC.B .exit - *
    DC.B 1
    DC.B test_ram_stage_1_wait_for_button - *
    DC.B 2
    DC.B test_ram_stage_2 - *
    DC.B 3
    DC.B test_ram_stage_3 - *
    DC.B 4
    DC.B test_ram_init - *
    DC.B 0

.exit:
    RTS


; =============================================================================
; TEST_RAM_INIT
; =============================================================================
; DESCRIPTION:
; Sets the test sub stage to '1', and prints the diagnostic test title.
;
; =============================================================================
test_ram_init:                                  SUBROUTINE
    LDX     #(str_error_ram + 6)
    JSR     test_lcd_set_write_pointer_to_position_7
    LDX     #str_push_1_button
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

; This variable is used to store the test result.
    CLR     test_stage_sub_2

    LDAB    #1
    STAB    <test_stage_sub

    RTS


; =============================================================================
; TEST_RAM_STAGE_1_WAIT_FOR_BUTTON
; =============================================================================
; DESCRIPTION:
; Waits for the user to press the '1' button to initiate the test.
;
; =============================================================================
test_ram_stage_1_wait_for_button:               SUBROUTINE
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_1
    BNE     .exit

    LDAB    #2
    STAB    <test_stage_sub

.exit:
    RTS

; =============================================================================
; TEST_RAM_STAGE_2
; =============================================================================
; DESCRIPTION:
; This stage performs the actual RAM tests.
; It tests writing the preset bit patterns 0xAA, and 0x55 to the first 2Kb of
; external RAM. It then backs up the higher 2Kb of RAM, and performs the same
; tests there, before restoring it.
; Refer to: https://stackoverflow.com/a/43924054/5931673
; =============================================================================
test_ram_stage_2:                               SUBROUTINE
    JSR     lcd_clear_line_2
    LDX     #str_under_test
    JSR     lcd_strcpy
    JSR     lcd_update

; Clear the first 2Kb of RAM.
    LDX     #$800
    CLRA
    CLRB
.clear_ram_loop:
    STD     0,x
    INX
    INX
    CPX     #$1000
    BNE     .clear_ram_loop

; Write 0x55 to the first 2Kb of RAM.
    LDX     #$800
    LDAA    #$55
.write_test_1_loop:
    CMPB    0,x
    BNE     .test_error_low_address

    STAA    0,x
    CMPA    0,x
    BNE     .test_error_low_address

    INX
    CPX     #$1000
    BNE     .write_test_1_loop

; Write 0xAA to the first 2Kb of RAM.
    LDX     #$800
    LDAA    #$AA
.write_test_2_loop:
    STAA    0,x
    CMPA    0,x
    BNE     .test_error_low_address

    INX
    CPX     #$1000
    BNE     .write_test_2_loop

    BRA     .backup_high_ram

.test_error_low_address:
    LDAA    #1
    STAA    <porta_current_target_frequency

.backup_high_ram:
    LDX     #$1000

.copy_ram_loop_1:
    LDD     0,x
    XGDX
    SUBD    #$800
    XGDX
    STD     0,x
    XGDX
    ADDD    #$802
    XGDX
    CPX     #$17A0
    BNE     .copy_ram_loop_1

; This section clears all RAM from 0x1000 to 0x1800.
    LDX     #$1000
    CLRA
    CLRB

.clear_high_ram_loop:
    STD     0,x
    INX
    INX
    CPX     #$17A0
    BNE     .clear_high_ram_loop

; The following section writes 0x55 to the first byte in each word.
    LDX     #$1000
    LDAA    #$55
.write_test_3_loop:
    CMPB    0,x
    BNE     .test_error_high_address

    STAA    0,x
    CMPA    0,x
    BNE     .test_error_high_address

    INX
    CPX     #$17A0
    BNE     .write_test_3_loop

; The following section writes 0xAA to the first byte in each word.
    LDX     #$1000
    LDAA    #$AA
.write_test_4_loop:
    STAA    0,x
    CMPA    0,x
    BNE     .test_error_high_address

    INX
    CPX     #$17A0
    BNE     .write_test_4_loop

    BRA     .restore_high_ram

.test_error_high_address:
    LDAA    #2
    ORAA    <porta_current_target_frequency

.restore_high_ram:
; The following section restores all the backed-up RAM from 0x800-0x1000 back
; to 0x1000-0x1800.
    LDX     #$800

.copy_ram_loop_2:
    LDD     0,x
    XGDX
    ADDD    #$800
    XGDX
    STD     0,x
    XGDX
    SUBD    #$7FE
    XGDX
    CPX     #$1000
    BNE     .copy_ram_loop_2

    LDAB    #3
    STAB    <test_stage_sub

    RTS


; =============================================================================
; TEST_RAM_STAGE_3
; =============================================================================
; DESCRIPTION:
; Prints the results of the diagnostic test.
; A result of '1' indicates an error in the low 2Kb, a result of '2' indicates
; an error in the higher 2Kb.
;
; =============================================================================
test_ram_stage_3:                               SUBROUTINE
    JSR     lcd_clear_line_2

; If this value is '0', the test results are okay.
    LDAA    <test_stage_sub_2
    ANDA    #%11
    BEQ     .print_result_ok

    LDX     #str_error_ram
    JSR     lcd_strcpy

    LDAA    <test_stage_sub_2
    ANDA    #1
    BEQ     .is_error_in_high_address

    JSR     lcd_print_number_single_digit

.is_error_in_high_address:
    LDAA    <test_stage_sub_2
    ANDA    #%10
    BEQ     .update_lcd_and_exit

    JSR     lcd_print_number_single_digit

.update_lcd_and_exit:
    JSR     lcd_update
    CLRB
    STAB    <portamento_direction

    RTS

.print_result_ok:
    LDX     #str_ok
    JSR     lcd_strcpy
    BRA     .update_lcd_and_exit

str_error_ram:                          DC "ERROR RAM", 0
str_under_test:                         DC "UNDER TEST", 0


; =============================================================================
; TEST_ROM
; =============================================================================
; LOCATION: 0xFD4D
;
; DESCRIPTION:
; Tests the ROM by calculating a checksum of the entire ROM memory in 64 byte
; 'blocks'. After summing all blocks, the final checksum byte is tested for
; correctness.
;
; =============================================================================
test_rom:
; The test 'sub-stage' variable is reset to '0xFF' when the stage is
; incremented.
; This will cause the test stage to be initialised when this subroutine
; is initially called.
; After the 64 'blocks' of the ROM binary have been tested, a sub-stage
; number equal to, or above 64 will be a no-op.
    LDAB    <test_stage_sub
    JSR     jumpoff

    DC.B test_rom_get_block_checksum - *
    DC.B $40
    DC.B test_rom_exit - *
    DC.B $FF
    DC.B test_rom_init - *
    DC.B 0


; =============================================================================
; TEST_ROM_INIT
; =============================================================================
; LOCATION: 0xFD58
;
; DESCRIPTION:
; This subroutine initialises the test stage variables used in the ROM test
; stage.
;
; =============================================================================
test_rom_init:
; 'TEST #' is already written to the LCD.
    LDX     #str_rom
    JSR     test_lcd_set_write_pointer_to_position_7
    JSR     lcd_update

; Reset test stage variables.
    CLR     test_stage_sub_2
    CLR     test_stage_sub

    RTS


; =============================================================================
; TEST_ROM_GET_BLOCK_CHECKSUM
; =============================================================================
; LOCATION: 0xFD68
;
; DESCRIPTION:
; Calculates the checksum for a 256 byte 'block' of the ROM binary.
; This checksum is calculated by summing the individual bytes in the block,
; storing the sum in a single byte, and ignoring the resulting overflow.
; After every byte in the binary has been summed, the expected result is that
; the final sum of all blocks is '0'.
; This function is called 64 times in total to sum all of the binary.
; In order to implement this test, a 'checksum remainder byte' is stored at
; the start of the ROM, which rounds the checksum calculation off to '0'.
;
; =============================================================================
test_rom_get_block_checksum:                    SUBROUTINE
    LDD     #$C000 ; Start of ROM memory.

; Add the current test sub-stage to ACCA.
; Since the address is in ACCA+ACCB, this will effectively increment the
; block pointer by 256.
; The block pointer is then transferred to IX.
    ADDA    <test_stage_sub
    XGDX

; ACCB is used as an iterator for a loop from 0-256.
; In the loop it is decremented prior to comparing against zero, so it will
; run 256 times in total.
; ACCA is used to store the checksum for the current 'block'.
    CLRB
    LDAA    <test_stage_sub_2

.get_block_checksum_loop:
; Add the contents of the memory to the checksum.
    ADDA    0,x
    INX
    DECB
    BNE     .get_block_checksum_loop

    STAA    <test_stage_sub_2

; Test whether IX has overflowed to 0.
; This indicates that the entire ROM memory has been summed.
    CPX     #0
    BNE     .increment_block

; Compare the whole binary's 'checksum' against '0'.
    CMPA    #0
    BNE     test_rom_checksum_error

    LDX     #str_ok

.print_message:
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

.increment_block:
    INC     portamento_direction

test_rom_exit:
    RTS

test_rom_checksum_error:
    LDX     #str_test_err
    BRA     .print_message

str_rom:                                DC "ROM", 0


; =============================================================================
; TEST_EG_OP
; =============================================================================
; DESCRIPTION:
; This diagnostic routine tests the synth's EGS, and OP chips.
; It does so by playing notes from several preset test patches.
;
; =============================================================================
test_eg_op:                                     SUBROUTINE
    LDAB    <portamento_direction
    JSR     jumpoff

    DC.B test_eg_op_wait_to_start - *
    DC.B 1
    DC.B test_eg_op_load_next_test_stage - *
    DC.B 2
    DC.B test_eg_op_add_voice - *
    DC.B 3
    DC.B test_eg_op_prompt_for_advance - *
    DC.B $67
    DC.B test_eg_op_remove_voice - *
    DC.B $68
    DC.B test_eg_op_prompt_for_advance - *
    DC.B $CC
    DC.B test_eg_op_repeat - *
    DC.B $FF
    DC.B test_eg_op_init - *
    DC.B 0


test_eg_op_init:
    LDX     #str_eg_op
    JSR     test_lcd_set_write_pointer_to_position_7
    LDX     #str_push_1_button
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update

    CLR     test_stage_sub_2
    CLR     test_stage_sub
    RTS


; =============================================================================
; TEST_EG_OP_WAIT_TO_START
; =============================================================================
; DESCRIPTION:
; Scans for front panel input to test whether the '1' button was pressed.
; This initiates the test routine.
; Until this is pressed, the diagnostic routine will 'wait' by re-entering this
; subroutine repeatedly.
;
; =============================================================================
test_eg_op_wait_to_start:             SUBROUTINE
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_1
    BNE     .exit

    INC     portamento_direction

.exit:
    RTS


; =============================================================================
; TEST_EG_OP_LOAD_NEXT_TEST_STAGE
; =============================================================================
; DESCRIPTION:
; Loads the next test 'sub-stage'.
; This prints the test stage name, and loads the associated patch.
;
; =============================================================================
test_eg_op_load_next_test_stage:                SUBROUTINE
    JSR     lcd_clear_line_2

; Load the test stage string offset.
    LDX     #table_test_eg_op_string_offsets
    LDAB    <test_stage_sub_2
    ABX
    LDAB    0,x
    ABX

; Print the test stage string.
    JSR     test_lcd_set_write_pointer_to_line_2
    JSR     lcd_update
    JSR     voice_reset_egs
    JSR     voice_reset_frequency_data
    LDX     #test_eg_op_patch_buffer

; Load the test patch.
    LDAB    <test_stage_sub_2
    LDAA    #64
    MUL
    ABX
    JSR     patch_deserialise_to_edit_from_ptr_and_reload
    JSR     patch_activate

; Increment the test sub-stage.
    LDAA    <test_stage_sub_2
    INCA
    CMPA    #3
    BCS     .store_sub_stage

; If the sub-stage has reached 3, reset.
    CLRA

.store_sub_stage:
    STAA    <test_stage_sub_2
    INC     portamento_direction

    RTS


; =============================================================================
; TEST_EG_OP_ADD_VOICE
; =============================================================================
; DESCRIPTION:
; Initiates playing of the test note.
;
; =============================================================================
test_eg_op_add_voice:                           SUBROUTINE
    LDAB    #69
    JSR     voice_add
    INC     portamento_direction

    RTS


; =============================================================================
; TEST_EG_OP_PROMPT_FOR_ADVANCE
; =============================================================================
; DESCRIPTION:
; Scans for front panel input to test whether the '1' button was pressed.
; This resets the test back to the start, and initiates the loading of the next
; test stage.
; This test subroutine will be loaded continuously until the test 'stage' will
; have advanced enough to proceed.
;
; =============================================================================
test_eg_op_prompt_for_advance:                  SUBROUTINE
; Wait for button 1 to be pushed.
; If any other button pushed, reset the test stage?
    JSR     input_read_front_panel
    CMPB    #INPUT_BUTTON_1
    BNE     .delay_and_advance_stage

; If the '1' button is pressed, reset the test back to the first stage.
    LDAA    #1
    STAA    <test_stage_sub
    BRA     .exit

.delay_and_advance_stage:
    LDX     #1000

.delay_loop:
    DEX
    BNE     .delay_loop

    INC     portamento_direction

.exit:
    RTS


; =============================================================================
; TEST_EG_OP_REMOVE_VOICE
; =============================================================================
; DESCRIPTION:
; Removes the test voice
;
; =============================================================================
test_eg_op_remove_voice:                        SUBROUTINE
    LDAB    #69
    JSR     voice_remove
    INC     test_stage_sub

    RTS


; =============================================================================
; TEST_EG_OP_REPEAT
; =============================================================================
; DESCRIPTION:
; Repeats the diagnostic routine by resetting the test sub-stage.
; This causes a new note to be played.
;
; =============================================================================
test_eg_op_repeat:                              SUBROUTINE
    LDAA    #2
    STAA    <test_stage_sub

    RTS

str_eg_op:                              DC "EG/OP", 0

table_test_eg_op_string_offsets:
    DC.B str_test_envelope - *
    DC.B str_test_modulation - *
    DC.B str_test_feedback - *

str_test_envelope:                      DC "envelope", 0
str_test_modulation:                    DC "modulation", 0
str_test_feedback:                      DC "feedback", 0

; =============================================================================
; The patches used in the EG/OP test stages.
; =============================================================================
test_eg_op_patch_buffer:
    DC.B $63, $63, $63, $63, $63
    DC.B $63, $63, 0, 0, 0, 0
    DC.B 1, 0, 7, $32, $63, $63
    DC.B $38, $63, $63, $63, 0
    DC.B 0, 0, $63, 1, 0, 7, $32
    DC.B $63, $63, $38, $63, $63
    DC.B $63, 0, 0, 0, $63, 1
    DC.B 0, 7, $32, $63, $63
    DC.B $38, $63, $63, $63, 0
    DC.B 0, 0, $63, 1, 0, 7, 7
    DC.B 8, 0, 0, 0, 0, 0, $C
    DC.B $63, $63, $63, $63, $63
    DC.B $63, $63, 0, 0, 0, 0
    DC.B 1, 0, 7, $63, $63, $63
    DC.B $63, $63, $63, $63, 0
    DC.B 0, 0, 0, 1, 0, 7, $43
    DC.B $32, $20, $32, $4B, $4F
    DC.B $59, 0, 0, 0, $5B, 1
    DC.B 0, 7, $63, $63, $63
    DC.B $31, $63, $63, $63, 0
    DC.B 0, 0, $63, 1, 0, 7, 0
    DC.B 8, 0, 0, 0, 0, 0, $C
    DC.B $63, $63, $63, $63, $63
    DC.B $63, $63, 0, 0, 0, 0
    DC.B 1, 0, 7, $63, $63, $63
    DC.B $63, $63, $63, $63, 0
    DC.B 0, 0, 0, 1, 0, 7, $4B
    DC.B $36, $23, 0, $1B, $39
    DC.B $63, 0, 0, 0, $44, 1
    DC.B 0, 7, $63, $63, $63
    DC.B $37, $63, $63, $63, 0
    DC.B 0, 0, $63, 1, 0, 7, 2
    DC.B $F, 0, 0, 0, 0, 0, $C


; =============================================================================
; TEST_AUTO_SCALING
; =============================================================================
; LOCATION: 0xFF17
;
; DESCRIPTION:
; This diagnostic test plays all notes in sequence.
; @TODO: I don't fully understand the significance of this test routine.
;
; =============================================================================
test_auto_scaling:                              SUBROUTINE
; The test 'sub-stage' variable is reset to '0xFF' when the stage is
; incremented.
; This will cause the test stage to be initialised when this subroutine
; is initially called.
    LDAA    <test_stage_sub
    CMPA    #$FF
    BNE     .begin_note

; Initialise the patch edit buffer, and activate the loaded patch.
    JSR     patch_init_edit_buffer
    JSR     patch_activate
    CLR     test_stage_sub_2

    LDX     #str_auto_scal
    JSR     test_lcd_set_write_pointer_to_position_7
    JSR     lcd_update

    BRA     .decrement_sub_stage_and_delay

.begin_note:
; The test sub stage variable tracks how long to play each note.
; If it has reached zero, remove the voice, and begin again.
    LDAA    <test_stage_sub
    BEQ     .remove_voice

; This value was decremented at the start of the function.
; If it is one below this value, add the voice. Otherwise delay.
    CMPA    #$FE
    BNE     .decrement_sub_stage_and_delay

; If the sub stage 2 is below 61, branch.
; This effectively causes the note range to span from C2 (36) - C7 (96).
    LDAB    <test_stage_sub_2
    CMPB    #61
    BCS     .add_voice

; Reset the test sub stage.
    CLRB
    STAB    <test_stage_sub_2

.add_voice:
    ADDB    #36
    JSR     voice_add

.decrement_sub_stage_and_delay:
    DEC     portamento_direction

.initialise_delay:
    LDX     #200

.delay_loop:
    DEX
    BNE     .delay_loop

    RTS

.remove_voice:
    LDAB    <test_stage_sub_2
    ADDB    #36
    JSR     voice_remove
    LDAA    #$FE
    STAA    <test_stage_sub
    INC     test_stage_sub_2
    BRA     .initialise_delay

str_auto_scal:                          DC "AUTO SCAL", 0


; =============================================================================
; TEST_EXIT
; =============================================================================
; DESCRIPTION:
; Exits the test routines and returns to the synth's normal functionality.
; This re-enables interrupts.
;
; =============================================================================
test_exit:                                      SUBROUTINE
; @TODO: I'm not sure what the stack trace looks like at this point.
; Presumably this is to break out of the UI subroutines that triggered the test
; routines.
    INS
    INS

; Re-enable the output-compare interrupt, and clear condition flags.
    LDAA    #TIMER_CTRL_EOCI
    STAA    <timer_ctrl_status

    CLRA
    TAP

    RTS

str_push_1_button:                      DC "push #1 button", 0

; =============================================================================
; This is more symbol table data leftover from the ROM's development.
; For more information, refer to:
; https://ajxs.me/blog/Hacking_the_Yamaha_DX9_To_Turn_It_Into_a_DX7.html#leftover_data
; =============================================================================
    DC.B   4
    DC 0, "`MONI65"
    DC.W $C409
    DC 0, "`MONI8 "
    DC.W $C40C
    DC 0, "`MONIX "
    DC.W $C40F
    DC 0, "`MONO  "
    DC.W $15CB
    DC 0, "`MONO.2"
    DC.W $E87D
    DC 0, "`MONOM "
    DC.W $C590
    DC 0, "`MONOM1"
    DC.W $C59A
    DC 0, "`MONOM2"
    DC.W $C5AD
    DC 0, "`MOTTOM"
    DC.W $D8
    DC 0, "`MS    "
    DC.W $18E0
    DC 0, "`MS.2"

; This is the main hardware vector table.
; This table contains the various interupt vectors used by the HD6303 CPU. It
; always sits in a fixed position at the end of the ROM.
    DC.W handler_reset
    DC.W handler_sci
    DC.W handler_reset
    DC.W handler_ocf
    DC.W handler_reset
    DC.W handler_reset
    DC.W handler_reset
    DC.W handler_reset
    DC.W handler_reset

    END
