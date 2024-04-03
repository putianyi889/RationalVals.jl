struct TypedEndsUnitRange{T,L,R} <: AbstractUnitRange{T}
    start::L
    stop::R
end
(:)(p::P, q::Q) where {P<:IntegerVal,Q<:Integer} = TypedEndsUnitRange{promote_type(P, Q),P,Q}(p, q)
(:)(p::P, q::Q) where {P<:Integer,Q<:IntegerVal} = TypedEndsUnitRange{promote_type(P, Q),P,Q}(p, q)

first(r::TypedEndsUnitRange) = r.start
last(r::TypedEndsUnitRange) = r.stop