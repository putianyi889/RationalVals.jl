# RationalVals

[![Build Status](https://github.com/putianyi889/RationalConstants.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/putianyi889/RationalVals.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package implements something like `Val` but is a `Number` so that they can be used in mathematical operations. There is `IntegerVal{p}()` that represents the integer `p` and `RationalVal{p,q}()` that represents the fraction `p/q`. The parameters allow a method to dispatch on values, which can be useful in certain situations.

As this is a low-level package, only a few special values are implemented for irrational functions. Without further specialization, general values will use the default fallback from Julia.