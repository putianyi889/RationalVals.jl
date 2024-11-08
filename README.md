# RationalVals

[![Build Status](https://github.com/putianyi889/RationalVals.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/putianyi889/RationalVals.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package implements something like `Val` but is a `Number` so that they can be used in mathematical operations. There is `IntegerVal{p}()` that represents the integer `p` and `RationalVal{p,q}()` that represents the fraction `p/q`. The parameters allow a method to dispatch on values, which can be useful in certain situations.

As this is a low-level package, only a few special values are implemented for irrational functions. Without further specialization, general values will use the default fallback from Julia.

## Comparison against similar packages
- [StaticNumbers.jl](https://github.com/perrutquist/StaticNumbers.jl)
  - It is not actively maintained. Last update was in 2022.
  - It has more generic types, such as `StaticBool`, `StaticInteger`, `StaticReal`, `StaticNumber`, etc.. RationalVals.jl only supports `IntegerVal` for `Int` and `RationalVal` for `Rational{Int}`. Overflowing is detected and prohibited.
  - It has less specializations. You need to use `@stat` to explicitly make use of the type parameters. RationalVals.jl focuses on specializations and does everything implicitly.
  - Since it's an old package, it uses "glue" solution. RationalVals.jl makes use of the post-1.9 package extensions.
- [Static.jl](https://github.com/SciML/Static.jl/)
  - It does not subtype `Number`, which reduces chance of ambiguities and downstream precompilation overhead. On the other hand, it loses generic support for number types shipped with base Julia.
  - The math function support is more incomplete than RationalVals.jl at the moment, although it is capable of supporting everything.

## What you might also want
- [IrrationalConstants.jl](https://github.com/JuliaMath/IrrationalConstants.jl)
- [Infinities.jl](https://github.com/JuliaMath/Infinities.jl)
