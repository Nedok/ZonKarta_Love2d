--[[
NOTE: Currently not well-tested!

2D cartesian vector
Originally written by BlackBulletIV
Modified and extended by weakman54

Use as:
[local] Vector = require "Vector"
myVec = Vector(2, 4)

uses x and y positions as the internal representation,
if the vector is used primarily as a polar vector, consider using
the polar version. (the polar vector class does not exist yet)
--]]

-- Localize functions to improve performance
local sqrt, atan2, sin, cos = math.sqrt, math.atan2, math.sin, math.cos
local ceil, floor = math.ceil, math.floor

local Vector = {}
Vector.__index = Vector

-- Constructors and helpers: ----------
function Vector.new(x, y)
  return setmetatable({ x = x or 0, y = y or 0 }, Vector)
end

function Vector:clone()
  return Vector.new(self.x, self.y)
end

function Vector:unpack()
  return self.x, self.y
end

function Vector.__tostring(a)
  return "(" .. a.x .. ", " .. a.y .. ")"
end

function Vector.isVector(a)
  return getmetatable(a) == Vector -- NOTE: this means that only this vector "class" returns true, so other objects that might work as vectors won't return true
end


-- Arithmetic operators: ----------
  function Vector.__add(a, b)
    if type(a) == "number" then
      return Vector.new(b.x + a, b.y + a)
    elseif type(b) == "number" then
      return Vector.new(a.x + b, a.y + b)
    else
      return Vector.new(a.x + b.x, a.y + b.y)
    end
  end

  function Vector.__sub(a, b)
    if type(a) == "number" then
      return Vector.new(b.x - a, b.y - a)
    elseif type(b) == "number" then
      return Vector.new(a.x - b, a.y - b)
    else
      return Vector.new(a.x - b.x, a.y - b.y)
    end
  end

  function Vector.__mul(a, b)
    if type(a) == "number" then
      return Vector.new(b.x * a, b.y * a)
    elseif type(b) == "number" then
      return Vector.new(a.x * b, a.y * b)
    else
      return Vector.new(a.x * b.x, a.y * b.y)
    end
  end

  function Vector.__div(a, b)
    if type(a) == "number" then
      return Vector.new(b.x / a, b.y / a)
    elseif type(b) == "number" then
      return Vector.new(a.x / b, a.y / b)
    else
      return Vector.new(a.x / b.x, a.y / b.y)
    end
  end

  function Vector.__unm(a)
    return Vector.new(-a.x, -a.y)
  end


-- Comparison operators: ----------
  function Vector.__eq(a, b)
    return a.x == b.x and a.y == b.y
  end

  function Vector.__lt(a, b)
    return a.x < b.x or (a.x == b.x and a.y < b.y)
  end

  function Vector.__le(a, b)
    return a.x <= b.x and a.y <= b.y
  end


-- Magnitude(length) operations: ----------
  function Vector:len()
    return sqrt(self.x * self.x + self.y * self.y)
  end
  Vector.magnitude = Vector.len

  function Vector:lenSq()
    return self.x * self.x + self.y * self.y
  end

  function Vector.distance(a, b)
    return (b - a):len()
  end

  function Vector.distanceSq(a, b)
    return (b - a):lenSq()
  end

  function Vector:normalize()
    local len = self:len()
    self.x = self.x / len
    self.y = self.y / len
    return self
  end

  function Vector:normalized()
    return self / self:len()
  end


-- Rotation operations (uses radians): ----------
  function Vector:angle()
    return atan2(self.y, self.x)
  end

  function Vector:setRotation(angle)
    local newX = cos(angle)
    local newY = sin(angle)
    local mag = self:len()

    self.x = newX * mag
    self.y = newY * mag
  end

  function Vector:rotate(phi)
    local c = cos(phi)
    local s = sin(phi)
    self.x = c * self.x - s * self.y
    self.y = s * self.x + c * self.y
    return self
  end

  function Vector:rotated(phi)
    return self:clone():rotate(phi)
  end


-- Other vector operations: ----------
  function Vector:perpendicular()
    return Vector.new(-self.y, self.x)
  end

  function Vector:projectOn(other)
    return (self * other) * other / other:lenSq()
  end

-- NOTE: this could also be called cross, but is technically incorrect
--       and has ambiguous interpretations
-- the determinant of the matrix described be the two vectors
-- Equals the area of the parallelogram spanned by both vectors.
  function Vector:det(other)
    return self.x * other.y - self.y * other.x
  end

  function Vector:dot(other)
    return self.x * other.x + self.y * other.y
  end


-- Ceil and floor operators: ----------
-- This calls math.ceil/floor on each component separately.
-- This is mostly useful for easy comparison between cartesian vectors.
-- For polar vectors, angle will very likely change by a lot.
  function Vector:ceil()
    self.x = ceil(self.x)
    self.y = ceil(self.y)
    return self
  end

  function Vector:ceiled()
    return self:clone():ceil()
  end

  function Vector:floor()
    self.x = floor(self.x)
    self.y = floor(self.y)
    return self
  end

  function Vector:floored()
    return self:clone():floor()
  end


-- Conversion operators: ----------
-- Note that the conversion to the same type is equated with clone,
-- this is to unify the interface for both types.
-- Also note that conversion to the other type currently does not
-- associate the returned table with any metatable, so it cannot be
-- used in any operations.
  function Vector:asPolar()
    return {
      r = self:len(),
      a = self:angle(),
    }
  end

  Vector.asCartesian = Vector.clone



  setmetatable(Vector, { __call = function(_, ...) return Vector.new(...) end })

  return Vector