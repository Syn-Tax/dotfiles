#include QMK_KEYBOARD_H


#define _BASE 0
#define _RAISE 1
#define _LOWER 2

// Fillers to make layering more clear

#define ____ KC_TRNS

// Mod Tap
#define SFT_ESC  SFT_T(KC_ESC)
#define CTL_BSPC CTL_T(KC_BSPC)
#define ALT_SPC  ALT_T(KC_SPC)
#define SFT_ENT  SFT_T(KC_ENT)
#define ALT_ESC  ALT_T(KC_ESC)

#define SFT_INS  LSFT(KC_INS)

#define KC_ML KC_MS_LEFT
#define KC_MR KC_MS_RIGHT
#define KC_MU KC_MS_UP
#define KC_MD KC_MS_DOWN
#define KC_MB1 KC_MS_BTN1
#define KC_MB2 KC_MS_BTN2

#define RAISE MO(_RAISE)
#define LOWER MO(_LOWER)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/* Base (dvorak)
 * ,----------------------------------,                             ,----------------------------------,
 * |   '  |   ,  |   .  |   p  |   y  |                             |   f  |   g  |   c  |   r  |   l  |
 * |------+------+------+------+------|                             |-------------+------+------+------|
 * |   a  |   o  |   e  |   u  |   i  |                             |   d  |   h  |   t  |   n  |   s  |
 * |------+------+------+------+------|                             |------|------+------+------+------|
 * |   ;  |   q  |   j  |   k  |   x  |                             |   b  |   m  |   w  |   v  |   z  |
 * |------+------+------+-------------,                             ,-------------+------+------+------,
 *        |  [   |   ]  |                                                         |   (  |   )  |
 *        '------+------'-------------'                             '-------------'------+------'
 *                      | ESC  |  BS  |                             | SPACE|ENTER |
 *                      |      |      |                             |      |      |
 *                      | ALT  |      |                             |      |      |
 *                      '------+------'                             '------+------'
 *                                    '------+------' '------+------'
 *                                    | RAISE| SHIFT| | LOWER| LGUI |
 *                                    '------+------' '------+------'
 *                                    | =    |  CTRL| | /    | TAB  |
 *                                    '------+------' '------+------'
 */

[_BASE] = LAYOUT( \
  KC_QUOT, KC_COMM, KC_DOT,  KC_P,    KC_Y,                                       KC_F, KC_G,    KC_C,    KC_R,   KC_L,    \
  KC_A,    KC_O,    KC_E,    KC_U,    KC_I,                                       KC_D, KC_H,    KC_T,    KC_N,   KC_S, \
  KC_SCLN, KC_Q,    KC_J,    KC_K,    KC_X,                                       KC_B, KC_M,    KC_W,    KC_V,   KC_Z, \
              KC_LBRC, KC_RBRC,                                                   KC_LPRN, KC_RPRN,                   \
                                      ALT_ESC, KC_BSPC,   KC_SPC,  KC_ENT,                                          \
                                      KC_LSFT, RAISE  ,   KC_LGUI, LOWER,                                           \
                                      KC_LCTL,   KC_EQL,  KC_TAB,  KC_SLSH
),

/* Raise
 * ,----------------------------------,                             ,----------------------------------,
 * | F1   | F2   | F3   | F4   | F5   |                             | VOL+ |      |      |      | right|
 * |------+------+------+------+------|                             |-------------+------+------+------|
 * | F6   | F7   | F8   | F9   | F10  |                             |      | left |      |      |      |
 * |------+------+------+------+------|                             |------|------+------+------+------|
 * | F11  | F12  | down | up   |      |                             | VOL- |      |      |      |      |
 * |------+------+------+-------------,                             ,-------------+------+------+------,
 *        |      |      |                                                         |      |      |
 *        '------+------'-------------'                             '-------------'------+------'
 *                      |      |      |                             |      |      |
 *                      |      |      |                             |      |      |
 *                      |      |      |                             |      |      |
 *                      '------+------'                             '------+------'
 *                                    '------+------' '------+------'
 *                                    |      |      | |      |      |
 *                                    '------+------' '------+------'
 *                                    |      | RESET| | RESET|      |
 *                                    '------+------' '------+------'
 */

[_RAISE] = LAYOUT( \
  KC_F1, KC_F2, KC_F3,     KC_F4, KC_F5,                          KC_VOLU, ____,    ____,    ____,  KC_RIGHT,   \
  KC_F6, KC_F7, KC_F8,     KC_F9, KC_F10,                         ____,    KC_LEFT, ____,    ____,  ____, \
  KC_F11,KC_F12,  KC_DOWN, KC_UP,  ____,                          KC_VOLD, ____,    ____,    ____,  ____,      \
        ____,  ____,                                                            ____,    ____,              \
                                   ____, ____,  ____, ____,                                                 \
                                   ____, ____,  ____, ____,                                                 \
                                   RESET,____,  ____, RESET                                                  \
),
/* Lower
 * ,----------------------------------,                             ,----------------------------------,
 * |      | &    | *    |SFTINS| \    |                             |      |  7   |  8   |  9   |      |
 * |------+------+------+------+------|                             |------+------+------+------+------|
 * |      | $    | %    | ^    | |    |                             |      |  4   |  8   |  9   |      |
 * |------+------+------+------+------|                             |------+------+------+------+------|
 * |      | !    | @    | #    | ~    |                             | 0    |  1   |  2   |  3   |      |
 * |------+------+------+-------------,                             ,-------------+------+------+------,
 *        | ~    | -    |                                                         |      |      |
 *        '------+------'-------------'                             '-------------'------+------'
 *                      |      |      |                             |      |      |
 *                      |      |      |                             |      |      |
 *                      |      |      |                             |      |      |
 *                      '------+------'                             '------+------'
 *                                    '------+------' '------+------'
 *                                    |      |      | |      |      |
 *                                    '------+------' '------+------'
 *                                    |      |      | |      |      |
 *                                    '------+------' '------+------'
 */

[_LOWER] = LAYOUT( \
  ____,    KC_AMPR,KC_ASTR, SFT_INS, KC_BSLS,                       ____,    KC_7,     KC_8,    KC_9,    ____,  \
  ____,    KC_DLR, KC_PERC, KC_CIRC, KC_PIPE,                       ____,    KC_4,     KC_5,    KC_6,    ____,    \
  ____,    KC_EXLM, KC_AT,  KC_HASH, ____,                          KC_0,    KC_1,     KC_2,    KC_3,    ____, \
           KC_GRV, KC_MINS,                                                               ____,    ____,             \
                                             ____, ____,  ____, ____,                                               \
                                             ____, ____,  ____, ____,                                               \
                                             ____, ____,  ____, ____                                                \
)
};

void persistent_default_layer_set(uint16_t default_layer) {
  eeconfig_update_default_layer(default_layer);
  default_layer_set(default_layer);
}
