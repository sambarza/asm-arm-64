# How to assembly and link on MacOSX manually?

## Assembly
`as -arch arm64 Listing1-1.S -o Listing1-1.o`

## Link
`ld -o Listing1-1 Listing1-1.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _main -arch arm64`

# A more easy way?
`gcc -v -o Listing1-1 Listing1-1.S`

`-v` is for verbose, it will show you the commands it used to assembly and link.