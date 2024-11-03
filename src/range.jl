struct TypedEndsUnitRange{T<:Integer,L<:Integer,R<:Integer} <: AbstractUnitRange{T}
    start::L
    stop::R
end
(:)(p::P, q::Q) where {P<:IntegerVal,Q<:Integer} = TypedEndsUnitRange{promote_type(P, Q),P,Q}(p, q)
(:)(p::P, q::Q) where {P<:Integer,Q<:IntegerVal} = TypedEndsUnitRange{promote_type(P, Q),P,Q}(p, q)

first(r::TypedEndsUnitRange) = r.start
last(r::TypedEndsUnitRange) = r.stop

getindex(r::TypedEndsUnitRange{S,<:RationalValUnion}, i::IntegerVal) where S = first(r) + i - IntegerVal{1}()
getindex(r::TypedEndsUnitRange{S}, s::AbstractUnitRange{T}) where {S,T<:Integer} = r[first(s)]:r[last(s)]

oneto(r::IntegerVal) = IntegerVal(1):r