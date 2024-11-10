const SMAOTM = LinearAlgebra.StridedMaybeAdjOrTransMat

+(::IntegerVal{0}, ::IntegerVal{0}) = IntegerVal{0}()
for T in (Integer, Rational, AbstractIrrational, RationalValUnion)
    @eval +(::IntegerVal{0}, b::$T) = b
    @eval +(a::$T, ::IntegerVal{0}) = a
end

*(::IntegerVal{1}, ::IntegerVal{1}) = IntegerVal{1}()
for T in (Integer, Rational, AbstractIrrational, RationalValUnion, IntegerVal{0}, IntegerVal{-1})
    @eval *(::IntegerVal{1}, b::$T) = b
    @eval *(a::$T, ::IntegerVal{1}) = a
end

*(::IntegerVal{0}, ::IntegerVal{0}) = IntegerVal{0}()
for T in (Integer, Rational, AbstractIrrational, RationalValUnion, IntegerVal{-1})
    @eval *(::IntegerVal{0}, ::$T) = IntegerVal{0}()
    @eval *(::$T, ::IntegerVal{0}) = IntegerVal{0}()
end

for T in (RationalValUnion, IntegerVal{-1}, Integer, Rational)
    @eval *(a::$T, ::IntegerVal{-1}) = -a
end
for T in (RationalValUnion, Integer, Rational)
    @eval *(::IntegerVal{-1}, b::$T) = -b
end

for T in (Number, RationalValUnion, BitArray, Complex, IntegerVal{1},
    StepRangeLen{<:Real,<:Base.TwicePrecision}, Base.TwicePrecision,
    AbstractArray,
    LinearAlgebra.UpperHessenberg,
    LinearAlgebra.UpperTriangular,
    LinearAlgebra.UpperTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.LowerTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.UnitUpperTriangular,
    LinearAlgebra.UnitLowerTriangular,
    LinearAlgebra.LowerTriangular,
    LinearAlgebra.SymTridiagonal,
    LinearAlgebra.Bidiagonal,
    LinearAlgebra.Tridiagonal,
    LinearAlgebra.Diagonal,
    LinearAlgebra.UniformScaling,
    LinearAlgebra.Hermitian,
    LinearAlgebra.Symmetric,
    Dates.Period,
    StridedArray{<:Dates.Period})
    @eval /(a::$T, x::RationalValUnion) = a * inv(x)
end
/(a::Rational, x::IntegerVal) = a * inv(x)

for T in (BigInt, BigFloat, Regex, Irrational{:ℯ}, Rational, Number,
    Complex, Complex{<:AbstractFloat}, Complex{<:Integer}, Complex{<:Rational},
    Float64, Float32, Float16,
    AbstractMatrix, AbstractMatrix{<:Integer},
    Union{AbstractString,AbstractChar},
    LinearAlgebra.AbstractQ,
    LinearAlgebra.Diagonal,
    LinearAlgebra.Tridiagonal,
    LinearAlgebra.UpperTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.LowerTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.UnitUpperTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.UnitLowerTriangular{<:Any,<:SMAOTM},
    LinearAlgebra.Hermitian,
    LinearAlgebra.Symmetric{<:Real},
    LinearAlgebra.Symmetric{<:Complex},
    LinearAlgebra.UniformScaling)
    @eval ^(a::$T, ::IntegerVal{p}) where {p} = Base.literal_pow(^, a, Val{p}())
end

^(::RationalVal{p1,q1}, r::IntegerVal) where {p1,q1} = IntegerVal{p1}()^r / IntegerVal{q1}()^r

for T in (Rational, Complex)
    @eval /(::IntegerVal{1}, x::$T) = inv(x)
end

/(::Missing, ::RationalValUnion) = missing

for T in (Bool, BigInt, Integer, Rational, AbstractIrrational, RationalVal, IntegerVal, IntegerVal{1}, RationalVal{1,2}, RationalVal{1,4}, RationalVal{1,3})
    @eval ^(::IntegerVal{0}, x::$T) = iszero(x)
end
for T in (Bool, BigInt, Integer, Rational, AbstractIrrational, RationalVal, IntegerVal{1}, IntegerVal, RationalVal{1,2}, RationalVal{1,4}, RationalVal{1,3})
    @eval ^(::IntegerVal{1}, ::$T) = IntegerVal{1}()
end
for T in (Irrational{:ℯ}, IntegerVal, RationalVal)
    @eval ^(a::$T, ::RationalVal{1,2}) = sqrt(a)
    @eval ^(a::$T, ::RationalVal{1,3}) = cbrt(a)
    @eval ^(a::$T, ::RationalVal{1,4}) = fourthroot(a)
end

for T in (TypedEndsStepRange, LinRange, StepRangeLen)
    @eval broadcasted(::DefaultArrayStyle{1}, ::typeof(*), x::RationalValUnion, r::$T) = x*_first(r):x*_step(r):x*last(r)
    @eval broadcasted(::DefaultArrayStyle{1}, ::typeof(*), ::IntegerVal{0}, r::$T) = ConstRange(IntegerVal{0}(), length(r))
end