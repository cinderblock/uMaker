// Minimal AVR program used to exercise the uMaker build system in CI.
// Doesn't do anything useful — just enough to produce a real .elf via
// the full uMaker AVR toolchain (compile, link, hex, size).

#include <avr/io.h>
#include <util/delay.h>

int main() {
  // Toggle a port pin so the compiler can't trivially eliminate everything.
  DDRB |= (1 << 0);
  while (1) {
    PORTB ^= (1 << 0);
    _delay_ms(500);
  }
}
