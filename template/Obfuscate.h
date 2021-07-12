// http://www.rohitab.com/discuss/topic/39611-malware-related-compile-time-hacks-with-c11/
// https://github.com/Rednick16/cpp11-compile-time-string-obfuscation

#include <stdio.h>
#include <stdint.h>

//-------------------------------------------------------------//
// "Malware related compile-time hacks with C++11" by LeFF   //
// You can use this code however you like, I just don't really //
// give a shit, but if you feel some respect for me, please //
// don't cut off this comment when copy-pasting... ;-)       //
//-------------------------------------------------------------//

#if defined(_MSC_VER)
#define ALWAYS_INLINE __forceinline
#else 
#define ALWAYS_INLINE __attribute__((always_inline))
#endif
 
// Usage examples:
void setup()    __attribute__((noinline));
void startAuthentication()  __attribute__((noinline));

#ifndef seed
    // I use current (compile time) as a seed
    // Convert time string (hh:mm:ss) into a number
    constexpr int seedToInt(char c) { return c - '0'; }
    const int seed = seedToInt(__TIME__[7]) +
                     seedToInt(__TIME__[6]) * 10 +
                     seedToInt(__TIME__[4]) * 60 +
                     seedToInt(__TIME__[3]) * 600 +
                     seedToInt(__TIME__[1]) * 3600 +
                     seedToInt(__TIME__[0]) * 36000;
#endif

// The constantify template is used to make sure that the result of constexpr
// function will be computed at compile-time instead of run-time
template <uintptr_t Const> struct 
vxCplConstantify { enum { Value = Const }; };

// Compile-time mod of a linear congruential pseudorandom number generator,
// the actual algorithm was taken from "Numerical Recipes" book
constexpr uintptr_t vxCplRandom(uintptr_t Id)
{ return (1013904223 + 1664525 * ((Id > 0) ? (vxCplRandom(Id - 1)) : (/*vxCPLSEED*/seed))) & 0xFFFFFFFF; }

// Compile-time random macros, can be used to randomize execution  
// path for separate builds, or compile-time trash code generation
#define vxRANDOM(Min, Max) (Min + (vxRAND() % (Max - Min + 1)))
#define vxRAND()           (vxCplConstantify<vxCplRandom(__COUNTER__ + 1)>::Value)

// Compile-time recursive mod of string hashing algorithm,
// the actual algorithm was taken from Qt library (this
// function isn't case sensitive due to vxCplTolower)
constexpr char   vxCplTolower(char Ch)                { return (Ch >= 'A' && Ch <= 'Z') ? (Ch - 'A' + 'a') : (Ch); }
constexpr uintptr_t vxCplHashPart3(char Ch, uintptr_t Hash) { return ((Hash << 4) + vxCplTolower(Ch)); }
constexpr uintptr_t vxCplHashPart2(char Ch, uintptr_t Hash) { return (vxCplHashPart3(Ch, Hash) ^ ((vxCplHashPart3(Ch, Hash) & 0xF0000000) >> 23)); }
constexpr uintptr_t vxCplHashPart1(char Ch, uintptr_t Hash) { return (vxCplHashPart2(Ch, Hash) & 0x0FFFFFFF); }
constexpr uintptr_t vxCplHash(const char* Str)           { return (*Str) ? (vxCplHashPart1(*Str, vxCplHash(Str + 1))) : (0); }

// Compile-time hashing macro, hash values changes using the first pseudorandom number in sequence
#define HASH(Str) (uintptr_t)(vxCplConstantify<vxCplHash(Str)>::Value ^ vxCplConstantify<vxCplRandom(1)>::Value)

// Compile-time generator for list of indexes (0, 1, 2, ...)
template <uintptr_t...> struct vxCplIndexList {};
template <typename  IndexList, uintptr_t Right> struct vxCplAppend;
template <uintptr_t... Left,      uintptr_t Right> struct vxCplAppend<vxCplIndexList<Left...>, Right> { typedef vxCplIndexList<Left..., Right> Result; };
template <uintptr_t N> struct vxCplIndexes { typedef typename vxCplAppend<typename vxCplIndexes<N - 1>::Result, N - 1>::Result Result; };
template <> struct vxCplIndexes<0> { typedef vxCplIndexList<> Result; };

// Compile-time string encryption of a single character
const char vxCplEncryptCharKey = (const char)vxRANDOM(0, 0xFF);
constexpr char ALWAYS_INLINE vxCplEncryptChar(const char Ch, uintptr_t Idx) { return Ch ^ (vxCplEncryptCharKey + Idx); }

// Compile-time string encryption class
template <typename IndexList> struct vxCplEncryptedString;
template <uintptr_t... Idx> struct vxCplEncryptedString<vxCplIndexList<Idx...> >
{
    char Value[sizeof...(Idx) + 1]; // Buffer for a string

    // Compile-time constructor
    constexpr ALWAYS_INLINE vxCplEncryptedString(const char* const Str)  
    : Value{ vxCplEncryptChar(Str[Idx], Idx)... } {}

    // Run-time decryption
    inline const char* decrypt()
    {
        for(uintptr_t t = 0; t < sizeof...(Idx); t++)
        { this->Value[t] = this->Value[t] ^ (vxCplEncryptCharKey + t); }
        this->Value[sizeof...(Idx)] = '\0'; return this->Value;
    }
};

// Compile-time string encryption macro
#define ENCRYPT(Str) (vxCplEncryptedString<vxCplIndexes<sizeof(Str) - 1>::Result>(Str).decrypt())

#ifdef __APPLE__
// Compile-time Objective-c string encryption macro
#define NSSENCRYPT(Str) @(ENCRYPT(Str))
#endif

// Compile-time offset string encryption macro, converts back to uint64_t.
#define ENCRYPTOFFSET(Str) strtoull(ENCRYPT(Str), NULL, 0)

// Compile-time hex string encryption macro, does same as ENCRYPT, but the naming is just more clear.
#define ENCRYPTHEX(Str) ENCRYPT(Str)
