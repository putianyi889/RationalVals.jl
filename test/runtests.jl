using RationalVals
using Test
using Aqua

v(p::Int) = IntegerVal{p}()
v(p::Rational{Int}) = RationalVal{numerator(p),denominator(p)}()

@testset "promotion" begin
    @test v(0) == 0
    @test v(1) == true
end

@testset "misc" begin
    @test inv(v(1)) ≡ v(1)
    @test deg2rad(v(0)) ≡ v(0)
    @test min(v(1),v(0)) ≡ v(0)
    @test max(v(1),v(0)) ≡ v(1)
    @test minmax(v(1),v(0)) ≡ (v(0),v(1))
end

@testset "special" begin
    @testset "sin" begin
        @test sin(v(0)) ≡ v(0)
        @test sind(v(90)) ≡ v(1)
        @test sind(v(180)) ≡ v(0)
        @test sinpi(v(1//2)) ≡ v(1)
        @test sinpi(v(2)) ≡ v(0)
        @test sinh(v(0)) ≡ v(0)
        @test asin(v(0)) ≡ v(0)
    end
    @testset "cos" begin
        @test cos(v(0)) ≡ v(1)
        @test cosd(v(0)) ≡ v(1)
        @test cosd(v(90)) ≡ v(0)
        @test cospi(v(-1//2)) ≡ v(0)
        @test acos(v(1)) ≡ v(0)
    end
    @testset "tan" begin
        @test tan(v(0)) ≡ v(0)
        @test tand(v(45)) ≡ v(1)
        @test tand(v(-180)) ≡ v(0)
        if VERSION >= v"1.10"
            @test tanpi(v(-2)) ≡ v(0)
        end
        @test tanh(v(0)) ≡ v(0)
        @test atan(v(0)) ≡ v(0)
    end
    @testset "sincos" begin
        @test sincos(v(0)) ≡ (v(0),v(1))
        if VERSION >= v"1.3"
            @test sincosd(v(360)) ≡ (v(0),v(1))
        end
        if VERSION >= v"1.6"
            @test sincospi(v(-2)) ≡ (v(0),v(1))
        end
    end
    @testset "exp/log" begin
        @test exp(v(0)) ≡ v(1)
        @test log(v(1)) ≡ v(0)
        @test log(-1,v(1)) ≡ v(0)
        @test log2(v(1)) ≡ v(0)
        @test log10(v(1)) ≡ v(0)
        @test log1p(v(0)) ≡ v(0)
    end
    @testset "misc" begin
        @test sinc(v(0)) ≡ v(1)
        @test cosc(v(0)) ≡ v(0)
    end
end

@testset "range" begin
    @test IntegerVal{1}():IntegerVal{5}() isa TypedEndsUnitRange{Int}
    @test IntegerVal{1}():5 isa TypedEndsUnitRange{Int}
    @test 1:IntegerVal{5}() isa TypedEndsUnitRange{Int}
end

@static if VERSION >= v"1.9"
    @testset "extensions" begin
        @testset "Infinities" begin
            import Infinities
            r = IntegerVal{1}():Infinities.∞
            @test IntegerVal{1}():Infinities.∞ isa TypedEndsUnitRange{Int,IntegerVal{1},Infinities.InfiniteCardinal{0}}
            @test IntegerVal{1}():Infinities.ℵ₀ isa TypedEndsUnitRange{Int,IntegerVal{1},Infinities.InfiniteCardinal{0}}
            @test r[1] ≡ 1
            @test r[2] ≡ 2
            @test first(r) ≡ IntegerVal{1}()
            @test last(r) ≡ Infinities.ℵ₀
            @test r[1:10] ≡ 1:10
            @test r[IntegerVal{1}()] ≡ IntegerVal{1}()
        end
    end
end

@testset "Aqua" begin
    @testset "Aqua" begin
        Aqua.test_all(RationalVals)
    end
end
