
#region Vector2

function Vector2(_x = 0, _y = 0) constructor
{
	X = _x;
	Y = _y;
	
	static Length = function()
	{
		var s = sqr(X) + sqr(Y);
		if(s != 0)
		{
			return sqrt(s);
		}
		return 0;
	}
	static ToRotation = function()
	{
		return darctan2(Y,X);
	}
	
	#region math
	
	static IsEqualTo = function(_vector2)
	{
		return (X == _vector2.X && Y == _vector2.Y);
	}
	
	static Equals = function(_vector2)
	{
		X = _vector2.X;
		Y = _vector2.Y;
	}
	static Add = function(_vector2)
	{
		X += _vector2.X;
		Y += _vector2.Y;
	}
	static Subtract = function(_vector2)
	{
		X -= _vector2.X;
		Y -= _vector2.Y;
	}
	static Multiply = function(_value)
	{
		X *= _value;
		Y *= _value;
	}
	static MultiplyVector2 = function(_vector2)
	{
		X *= _vector2.X;
		Y *= _vector2.Y;
	}
	static Divide = function(_value)
	{
		X /= _value;
		Y /= _value;
	}
	static DivideVector2 = function(_vector2)
	{
		X /= _vector2.X;
		Y /= _vector2.Y;
	}
	static Lerp = function(_vector2, _value)
	{
		_vector2.Subtract(self);
		_vector2.Multiply(_value);
		self.Add(_vector2);
	}
	
	#endregion
	
	
}

function RotationToVector2(_angle)
{
	return new Vector2(dcos(_angle),dsin(_angle));
}

#endregion
#region Rectangle

function Rectangle(_x = 0, _y = 0, _width = 0, _height = 0) constructor
{
	X = _x;
	Y = _y;
	Width = _width;
	Height = _height;
	
	static Intersect = function(_rect)
	{
		return rectangle_in_rectangle(X,Y,X+Width,Y+Height, _rect.X,_rect.Y,_rect.X+_rect.Width,_rect.Y+_rect.Height);
	}
	
	static ColRect = function(_x, _y, _width, _height)
	{
		return rectangle_in_rectangle(X,Y,X+Width,Y+Height, _x,_y,_width,_height);
	}
	static ColPoint = function(_x, _y)
	{
		return point_in_rectangle(_x,_y, X,Y,X+Width,Y+Height);
	}
}

#endregion

#region AnimTools
function LerpArray(arr, amount, loop = false)
{
	var result = arr[0];
	var amt = amount;
	
	if(loop)
	{
		while(amt >= array_length(arr))
		{
			amt -= array_length(arr);
		}
		if(amt >= array_length(arr)-1)
		{
			var value1 = arr[array_length(arr)-1],
				value2 = arr[0],
				amt2 = amt-(array_length(arr)-1);
			return value1 + (value2-value1)*amt2;
		}
	}
	
	for(var i = 0; i < array_length(arr)-1; i++)
	{
		if((i+1) >= amt)
		{
			var value1 = arr[i],
				value2 = arr[i+1],
				amt2 = amt-i;
			result = value1 + (value2-value1)*amt2;
			break;
		}
	}
	return result;
}
function LerpArrayVector2(arr, amount, loop = false)
{
	var result = new Vector2(arr[0].X,arr[0].Y);
	var amt = amount;
	
	if(loop)
	{
		while(amt >= array_length(arr))
		{
			amt -= array_length(arr);
		}
		if(amt >= array_length(arr)-1)
		{
			var value1 = new Vector2(),
				value2 = new Vector2(),
				amt2 = amt-(array_length(arr)-1);
			
			value1.Equals(arr[array_length(arr)-1]);
			value2.Equals(arr[0]);
			
			var vf = new Vector2(value1.X,value1.Y);
			vf.Lerp(value2,amt2);
			return vf;
		}
	}
	
	for(var i = 0; i < array_length(arr)-1; i++)
	{
		if((i+1) >= amt)
		{
			var value1 = new Vector2(),
				value2 = new Vector2(),
				amt2 = amt-i;
			
			value1.Equals(arr[i]);
			value2.Equals(arr[i+1]);
			
			var vf = new Vector2(value1.X,value1.Y);
			vf.Lerp(value2,amt2);
			result = vf;
			break;
		}
	}
	return result;
}
#endregion

function object_is_in_array(_obj, _arr)
{
	for(var i = 0; i < array_length(_arr); i++)
	{
		if(_obj == _arr[i] || object_is_ancestor(_obj,_arr[i]))
		{
			return true;
		}
	}
	return false;
}

function FindArrayIndexInList(_list, _array, _skipInd = -1)
{
	for(var i = 0; i < ds_list_size(_list); i++)
	{
		if(is_array(_list[| i]))
		{
			var _listArray = _list[| i];
			var _flag = false;
			for(var j = 0; j < array_length(_listArray); j++)
			{
				if(_listArray[j] != _array[j] && j != _skipInd)
				{
					_flag = true;
					break;
				}
			}
			if(!_flag)
			{
				return i;
			}
		}
	}
	return -1;
}
