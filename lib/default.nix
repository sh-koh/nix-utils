{ lib, ... }:
{
  flake.lib = {
    upperFirstLetter =  word: lib.strings.toUpper (builtins.head (lib.strings.stringToCharacters word)) + lib.strings.concatStrings (builtins.tail (lib.strings.stringToCharacters word));
  };
}
