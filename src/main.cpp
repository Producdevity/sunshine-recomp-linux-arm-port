// Super Mario Sunshine (USA). The game's code is translated from the player's disc at first
// launch, or compiled in at build time for the reference build (SMS_COMPILED).
#include "gcrt/frontend.hpp"

int main(int argc, char** argv) {
    gcrt::GameInfo game{"Super Mario Sunshine", 448, {}, "GMSE01.symbols.txt", "GMSE01.cfg"};
#ifdef SMS_COMPILED
    game.program = gcrt::linked_program();
#endif
    return gcrt::run_frontend(game, argc, argv);
}
