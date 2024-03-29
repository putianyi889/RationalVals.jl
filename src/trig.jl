sin(::IntegerVal{0}) = IntegerVal{0}()
cos(::IntegerVal{0}) = IntegerVal{1}()

sind(p::RationalValUnion) = sinpi(p / IntegerVal{180}())
cosd(p::RationalValUnion) = cospi(p / IntegerVal{180}())
tand(p::RationalValUnion) = tanpi(p / IntegerVal{180}())

sinpi(::IntegerVal) = IntegerVal{0}()
sinpi(q::RationalVal{p,2}) where {p} = cospi(q - RationalVal{1,2}())
cospi(p::IntegerVal) = IntegerVal{-1}()^p
cospi(::RationalVal{p,2}) where {p} = IntegerVal{0}()

sincos(p::RationalValUnion) = (sin(p), cos(p))
tan(p::RationalValUnion) = sin(p) / cos(p)
tanpi(p::IntegerVal) = sinpi(p) / cospi(p)
tanpi(q::RationalVal{p,4}) where p = cospi(q*IntegerVal{2}()-RationalVal{1,2}())

sinh(::IntegerVal{0}) = IntegerVal{0}()
cosh(::IntegerVal{0}) = IntegerVal{1}()
tanh(p::RationalValUnion) = sinh(p) / cosh(p)

asin(::IntegerVal{0}) = IntegerVal{0}()
acos(::IntegerVal{1}) = IntegerVal{0}()
atan(::IntegerVal{0}) = IntegerVal{0}()

for (p,asd) in ((0,0), (1,90), (-1,-90))
    # asd = asind(p)
    @eval asind(::IntegerVal{$p}) = IntegerVal{$asd}()
    @eval acosd(::IntegerVal{$p}) = IntegerVal{$(90-asd)}()
end
for (p,q,asd) in ((1,2,30), (-1,2,-30))
    # asd = asind(p/q)
    @eval asind(::RationalVal{$p,$q}) = IntegerVal{$asd}()
    @eval acosd(::RationalVal{$p,$q}) = IntegerVal{$(90-asd)}()
end

atand(::IntegerVal{0}) = IntegerVal{0}()
atand(::IntegerVal{1}) = IntegerVal{45}()
atand(::IntegerVal{-1}) = IntegerVal{-45}()

sinc(::IntegerVal{0}) = IntegerVal{1}()
cosc(::IntegerVal{0}) = IntegerVal{0}()