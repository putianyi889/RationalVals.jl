module RationalVals

import Base: +, -, *, /, ^, //, show, inv, promote_rule, zero, one, cmp, min, max, minmax, deg2rad, rad2deg, isqrt, (:), step, first # misc
import Base: iszero, isone, <, ==, <= # boolean
import Base: fld, cld, mod, rem, fld1, mod1 # integer
import Base: sin, cos, tan,
    sind, cosd, tand,
    sinpi, cospi, tanpi,
    asin, acos, atan,
    asind, acosd, atand,
    sinh, cosh, tanh,
    sincos, sinc, cosc # trigonometric
import Base: log, log2, log10, log1p,
    exp, exp2, exp10, expm1 # power

export IntegerVal, RationalVal, TypedEndsUnitRange

"""
    IntegerVal{p} <: Integer

The integer `p`. See also [`RationalVal`](@ref). The parameter allows one to dispatch on value.
"""
struct IntegerVal{p} <: Integer end

IntegerVal(p::Integer) = IntegerVal{Int(p)}()

"""
    RationalVal{p,q} <: Real

The rational `p//q` where `q!=1`. See also [`IntegerVal`](@ref). The parameter allows one to dispatch on value.
"""
struct RationalVal{p,q} <: Real end

const RationalValUnion = Union{<:IntegerVal,<:RationalVal}

@inline _value(::IntegerVal{p}) where {p} = p
@inline _value(::RationalVal{p,q}) where {p,q} = p // q

@inline RationalValUnion(p) = isinteger(p) ? IntegerVal{Int(numerator(p))}() : RationalVal{Int(numerator(p)),Int(denominator(p))}()

promote_rule(::Type{T}, ::Type{<:IntegerVal}) where {T<:Integer} = T
promote_rule(::Type{BigInt}, ::Type{<:IntegerVal}) = BigInt
promote_rule(::Type{Bool}, ::Type{<:IntegerVal}) = Int
promote_rule(::Type{Bool}, ::Type{IntegerVal{0}}) = Bool
promote_rule(::Type{Bool}, ::Type{IntegerVal{1}}) = Bool
promote_rule(::Type{T}, ::Type{<:RationalVal}) where {T<:Integer} = Rational{T}
promote_rule(::Type{Bool}, ::Type{<:RationalVal}) = Rational{Int}
promote_rule(::Type{<:IntegerVal}, ::Type{<:IntegerVal}) = Int
promote_rule(::Type{<:RationalValUnion}, ::Type{<:RationalValUnion}) = Rational{Int}

(::Type{T})(p::RationalValUnion) where {T<:Real} = T(_value(p))

for f in (:-,:isqrt)
    @eval $f(p::RationalValUnion) = RationalValUnion($f(_value(p)))
end
zero(::RationalValUnion) = IntegerVal{0}()
zero(::Type{<:RationalValUnion}) = IntegerVal{0}()
one(::RationalValUnion) = IntegerVal{1}()
one(::Type{<:RationalValUnion}) = IntegerVal{1}()

# Boolean
for f in (:iszero, :isone)
    @eval $f(p::RationalValUnion) = $f(_value(p))
end
for op in (:<, :(==), :(<=))
    @eval $op(p::RationalValUnion, q::RationalValUnion) = $op(_value(p), _value(q))
end

inv(p::IntegerVal) = one(p) / p
minmax(p::RationalValUnion, q::RationalValUnion) = isless(_value(p), _value(q)) ? (p, q) : (q, p)

for op in (:+, :-, :*, ://, :fld, :cld, :mod, :rem, :fld1, :mod1, :cmp, :min, :max)
    @eval $op(p::RationalValUnion, q::RationalValUnion) = RationalValUnion($op(_value(p), _value(q)))
end
/(p::RationalValUnion, q::RationalValUnion) = RationalValUnion(_value(p) // _value(q))

include("arithmetic.jl")
include("power.jl")
include("trig.jl")
include("range.jl")

deg2rad(::IntegerVal{0}) = IntegerVal{0}()
rad2deg(::IntegerVal{0}) = IntegerVal{0}()

# hypot

show(io::IO, ::RationalVal{1,2}) = print(io, "½")
show(io::IO, ::RationalVal{1,4}) = print(io, "¼")
show(io::IO, ::RationalVal{3,4}) = print(io, "¾")
show(io::IO, ::RationalVal{-1,2}) = print(io, "-½")
show(io::IO, ::RationalVal{-1,4}) = print(io, "-¼")
show(io::IO, ::RationalVal{-3,4}) = print(io, "-¾")

# ambiguities
import Base: Float16, BigFloat, Bool, BigInt, Integer, Rational

for T in (Integer, Rational, AbstractIrrational, RationalValUnion)
    @eval +(::IntegerVal{0}, b::$T) = b
end
for T in (Integer, Rational, AbstractIrrational, RationalValUnion)
    @eval +(a::$T, ::IntegerVal{0}) = a
end
for T in (Integer, Rational, AbstractIrrational, RationalValUnion, IntegerVal{0}, IntegerVal{1})
    @eval *(::IntegerVal{1}, b::$T) = b
end
for T in (Integer, Rational, AbstractIrrational, RationalValUnion, IntegerVal{0})
    @eval *(a::$T, ::IntegerVal{1}) = a
end
for T in (Integer, Rational, AbstractIrrational, RationalValUnion)
    @eval *(::IntegerVal{0}, ::$T) = IntegerVal{0}()
end
for T in (Integer, Rational, AbstractIrrational, RationalValUnion, IntegerVal{0})
    @eval *(::$T, ::IntegerVal{0}) = IntegerVal{0}()
end
for T in (Float16, Float32, Float64, BigFloat, BigInt, Rational, AbstractIrrational, Irrational{:ℯ}, RationalVal, IntegerVal, IntegerVal{0}, IntegerVal{-1}, IntegerVal{1})
    @eval ^(::$T, ::IntegerVal{0}) = IntegerVal{1}()
end
for T in (Float16, Float32, Float64, BigFloat, BigInt, Rational, AbstractIrrational, Irrational{:ℯ}, IntegerVal, RationalVal, IntegerVal{-1})
    @eval ^(x::$T, ::IntegerVal{1}) = x
end
for T in (Bool, BigInt, Integer, Rational, AbstractIrrational)
    @eval ^(::IntegerVal{0}, x::$T) = iszero(x)
end
for T in (RationalVal, IntegerVal, IntegerVal{1})
    @eval ^(::IntegerVal{0}, x::$T) = IntegerVal{0}()
end
for T in (Bool, BigInt, Integer, Rational, AbstractIrrational, RationalVal, IntegerVal{1}, IntegerVal)
    @eval ^(::IntegerVal{1}, ::$T) = IntegerVal{1}()
end
for T in (Base.TwicePrecision, Complex, AbstractChar)
    @eval RationalValUnion(x::$T) = RationalValUnion(Real(x))
end
for T in (:Float16, :BigFloat, :BigInt, :Integer, :Rational)
    @eval $T(p::IntegerVal) = $T(_value(p))
end
for T in (:Bool,)
    @eval $T(p::RationalValUnion) = $T(_value(p))
end

+(::IntegerVal{0}, ::IntegerVal{0}) = IntegerVal{0}()
^(::IntegerVal{-1}, x::BigInt) = isodd(x) ? -one(x) : one(x)
^(::IntegerVal{-1}, ::IntegerVal{p}) where {p} = isodd(p) ? IntegerVal{-1}() : IntegerVal{1}()
^(::IntegerVal{-1}, x::Bool) = x ? -1 : 1

log(::Irrational{:ℯ}, ::IntegerVal{1}) = IntegerVal{0}()

promote_rule(::Type{<:IntegerVal}, ::Type{<:RationalVal}) = Rational{Int}

IntegerVal(p::IntegerVal) = p
RationalValUnion(x::RationalValUnion) = x
Rational{T}(p::IntegerVal) where {T<:Integer} = Rational{T}(_value(p))

(:)(p::P, q::Q) where {P<:IntegerVal,Q<:IntegerVal} = TypedEndsUnitRange{promote_type(P, Q),P,Q}(p, q)

end
