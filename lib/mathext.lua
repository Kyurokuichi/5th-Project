







math.angle = function(x1,y1,x2,y2) return math.atan2(y2 - y1,x2 - x1) end

math.cerp = function(x1,x2,t) local f = (1 - math.cos(t * math.pi)) * 0.5 return x1 * (1 - f) + x2 * f end
math.clamp = function(min,max,n) return math.min(math.max(min, n), max) end

math.dist = function(x1,x2) return math.abs(x1 - x2) end
math.dist2 = function(x1,y1,x2,y2) return ((x2 - x1)^2 + (y2 - y1)^2)^0.5 end
math.dist3 = function(x1,y1,z1,x2,y2,z2) return ((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)^0.5 end

math.lerp = function(x1,x2,t) return (1 - t) * x1 + t * x2 end
math.lerp2 = function(x1,x2,t) return x1 + (x2 - x1) * t end

math.norm = function(x,y) local l = (x * x + y * y)^0.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end

math.round = function(n)
  local l = math.floor(n)
  local r = n - l
  if r >= 0.5 then return math.ceil(n) else return l end
end

math.round2 = function(n, d) return tonumber(string.format("%." .. (d or 0) .. "f", n)) end

math.sign = function(n) return n > 0 and 1 or n < 0 and -1 or 0 end

--[[ ease function
 b = begin; c = (begin - end); t = time; d = duration;
]]

math.ease = {
  linear = function(b, c, t, d) return c * t / d + b end,

  inQuad = function(b, c, t, d) t = t / d return c * (t ^ 2) + b end,

  outQuad = function(b, c, t, d) t = t / d return -c * t * (t - 2) + b end,

  inOutQuad = function(b, c, t, d)
    t = t / d * 2
    if t < 1 then
      return c / 2 * (t ^ 2) + b
    else
      return -c / 2 * ((t - 1) * (t - 3) - 1) + b
    end
  end,

  outInQuad = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outQuad(b, c / 2, t * 2, d)
    else
      return math.ease.inQuad(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inCubic = function(b, c, t, d) t = t / d return c * (t ^ 3) + b end,

  outCubic = function(b, c, t, d) t = t / d - 1 return c * (t ^ 3 + 1) + b end,

  inOutCubic = function(b, c, t, d)
    t = t / d * 2
    if t < 1 then
      return c / 2 * t * t * t + b
    else t = t - 2
      return c / 2 * (t * t * t + 2) + b
    end
  end,

  outInCubic = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outCubic(b, c / 2, t * 2, d)
    else
      return math.ease.inCubic(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inQuart = function(b, c, t, d) t = t / d return c * (t ^ 4) + b end,

  outQuart = function(b, c, t, d)
    t = t / d - 1
    return -c * (t ^ 4 - 1) + b
  end,

  inOutQuart = function(b, c, t, d)
    t = t / d * 2
    if t < 1 then
      return c / 2 * (t ^ 4) + b
    else
      t = t - 2
      return -c / 2 * (t ^ 4 - 2) + b
    end
  end,

  outInQuart = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outQuart(b, c / 2, t * 2, d)
    else
      return math.ease.inQuart(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inQuint = function(b, c, t, d)
    t = t / d
    return c * (t ^ 5) + b
  end,

  outQuint = function(b, c, t, d) t = t / d - 1 return c * (t ^ 5 + 1) + b end,

  inOutQuint = function(b, c, t, d)
    t = t / d * 2
    if t < 1 then
      return c / 2 * (t ^ 5) + b
    else
      t = t - 2
      return c / 2 * (t ^ 5 + 2) + b
    end
  end,

  outInQuint = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outQuint(b, c / 2, t * 2, d)
    else
      return math.ease.inQuint(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inSine = function(b, c, t, d) return -c * math.cos(t / d * (math.pi / 2)) + c + b end,

  outSine = function(b, c, t, d) return c * math.sin(t / d * (math.pi / 2)) + b end,

  inOutSine = function(b, c, t, d) return -c / 2 * (math.cos(math.pi * t / d) - 1) + b end,

  outInSine = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outSine(b, c / 2, t * 2, d)
    else
      return math.ease.inSine(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inExpo = function(b, c, t, d)
    if t == 0 then
      return b
    else
      return c * (2 ^ (10 * (t / d - 1))) + b - c * 0.001
    end
  end,

  outExpo = function(b, c, t, d)
    if t == d then
      return b + c
    else
      return c * 1.001 * (-(2 ^ (-10 * t / d)) + 1) + b
    end
  end,

  inOutExpo = function(b, c, t, d)
    if t == 0 then return b end
    if t == d then return b + c end
    t = t / d * 2
    if t < 1 then
      return c / 2 * (2 ^ (10 * (t - 1))) + b - c * 0.0005
    else
      t = t - 1
      return c / 2 * 1.0005 * (-(2 ^ (-10 * t)) + 2) + b
    end
  end,

  outInExpo = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outExpo(b, c / 2, t * 2, d)
    else
      return math.ease.inExpo(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inCirc = function(b, c, t, d) t = t / d return(-c * (math.sqrt(1 - t ^ 2) - 1) + b) end,

  outCirc = function(b, c, t, d) t = t / d - 1 return(c * math.sqrt(1 - t ^ 2) + b) end,

  inOutCirc = function(b, c, t, d)
    t = t / d * 2
    if t < 1 then
      return -c / 2 * (math.sqrt(1 - t * t) - 1) + b
    else
      t = t - 2
      return c / 2 * (math.sqrt(1 - t * t) + 1) + b
    end
  end,

  outInCirc = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outCirc(b, c / 2, t * 2, d)
    else
      return math.ease.inCirc(b + c / 2, c / 2, (t * 2) - d, d)
    end
  end,

  inElastic = function(b, c, t, d, a, p)
    if t == 0 then return b end

    t = t / d

    if t == 1  then return b + c end

    if not p then p = d * 0.3 end

    local s

    if not a or a < math.abs(c) then
      a = c
      s = p / 4
    else
      s = p / (2 * math.pi) * math.asin(c/a)
    end

    t = t - 1

    return -(a * (2 ^ (10 * t)) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
  end,

  outElastic = function(b, c, t, d, a, p)
    if t == 0 then return b end

    t = t / d

    if t == 1 then return b + c end

    if not p then p = d * 0.3 end

    local s

    if not a or a < math.abs(c) then
      a = c
      s = p / 4
    else
      s = p / (2 * pi) * math.asin(c/a)
    end

    return a * (2 ^ (-10 * t)) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
  end,

  inOutElastic = function(b, c, t, d, a, p)
    if t == 0 then return b end

    t = t / d * 2

    if t == 2 then return b + c end

    if not p then p = d * (0.3 * 1.5) end
    if not a then a = 0 end

    local s

    if not a or a < math.abs(c) then
      a = c
      s = p / 4
    else
      s = p / (2 * pi) * math.asin(c / a)
    end

    if t < 1 then
      t = t - 1
      return -0.5 * (a * (2 ^ (10 * t)) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
    else
      t = t - 1
      return a * (2 ^ (-10 * t)) * math.sin((t * d - s) * (2 * math.pi) / p ) * 0.5 + c + b
    end
  end,

  outInElastic = function(b, c, t, d, a, p)
    if t < d / 2 then
      return math.ease.outElastic(b, c / 2, t * 2, d, a, p)
    else
      return math.ease.inElastic(b + c / 2, c / 2, (t * 2) - d, d, a, p)
    end
  end,

  inBack = function(b, c, t, d, s)
    if not s then s = 1.70158 end
    t = t / d
    return c * t * t * ((s + 1) * t - s) + b
  end,

  outBack = function(b, c, t, d, s)
    if not s then s = 1.70158 end
    t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b
  end,

  inOutBack = function(b, c, t, d, s)
    if not s then s = 1.70158 end
    s = s * 1.525
    t = t / d * 2
    if t < 1 then
      return c / 2 * (t * t * ((s + 1) * t - s)) + b
    else
      t = t - 2
      return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
    end
  end,

  outInBack = function(b, c, t, d, s)
    if t < d / 2 then
      return math.ease.outBack(b, c / 2, t * 2, d, s)
    else
      return math.ease.inBack(b + c / 2, c / 2, (t * 2) - d, d, s)
    end
  end,

  outBounce = function(b, c, t, d)
    t = t / d
    if t < 1 / 2.75 then
      return c * (7.5625 * t * t) + b
    elseif t < 2 / 2.75 then
      t = t - (1.5 / 2.75)
      return c * (7.5625 * t * t + 0.75) + b
    elseif t < 2.5 / 2.75 then
      t = t - (2.25 / 2.75)
      return c * (7.5625 * t * t + 0.9375) + b
    else
      t = t - (2.625 / 2.75)
      return c * (7.5625 * t * t + 0.984375) + b
    end
  end,

  inBounce = function(b, c, t, d)
    return c - math.ease.outBounce(0, c, d - t, d) + b
  end,

  inOutBounce = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.inBounce(0, c, t * 2, d) * 0.5 + b
    else
      return math.ease.outBounce(0, c, t * 2 - d, d) * 0.5 + c * 0.5 + b
    end
  end,

  outInBounce = function(b, c, t, d)
    if t < d / 2 then
      return math.ease.outBounce(b, c / 2, t * 2, d)
    else
      return math.ease.inBounce(b + c / 2, c / 2, (t * 2) -d, d)
    end
  end,
}
