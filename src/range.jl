struct IntegerValTo{S<:IntegerVal,T} <: AbstractUnitRange{T}
    stop::T
end
first(::IntegerValTo{S}) where S = S()

(:)(::IntegerVal{p}, q::Integer) where p = IntegerValTo{IntegerVal{p},typeof(q)}(max(oftype(q, p) - one(q), q))
(:)(::IntegerVal{1},q::Integer) = Base.OneTo(q)