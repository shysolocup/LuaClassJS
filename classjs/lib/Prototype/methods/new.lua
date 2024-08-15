return function(pl, payload, Prototype)

  function Prototype.new(name) return function(p)
		if not p then p = {} end;

		Prototype.__index = Prototype;

		local proto = {};
		
		for k, v in pairs(p) do
			proto[k] = pl.Config.useObjects and PrototypeItem.new(nil, v) or v;
			p[k] = nil;
		end

		p.__index = __protoindex;
		p.__newindex = __protonewindex;

		if not rbx or not pl.Config.disableCoolPrint then
			p.__tostring = pl.dump;
		end

		local self = setmetatable(p, Prototype);
		self.__name = name;
		self.__instances = {};
		self.__prototype = proto;

		if config.useObjects then
			for k, v in pairs(proto) do
				if type(v) == "table" then
					rawset(v, "__parent", self);
				end
			end
		end


		function self.__prototype.__isa(self, n)
			if type(n) == "table" then
				return n.__name == self.__name;
			else
				return n == self.__name;
			end
		end


		Prototype.__index = pl.__protoindex;
		Prototype.__newindex = pl.__protonewindex;

		self.__index = pl.__protoindex;
		self.__newindex = pl.__protonewindex;

		--[[if not rbx then
			self.__tostring = __prototostring(self);
		end]]


		if not rawget(self, "constructor") and not rawget(self.__prototype, "constructor") then
			local item

			if config.useObjects then
					item = PrototypeItem.new(self, function() end);
			else
					item = (function() end);
			end
				
			self.__prototype.constructor = item;


		elseif rawget(self, "constructor") or rawget(self.__prototype, "constructor") then
			local constructor;

			if rawget(self, "constructor") then
				constructor = rawget(self, "constructor");
			else
				constructor = rawget(self.__prototype, "constructor");
			end

			rawset(self, "constructor", nil);
			rawset(self.__prototype, "constructor", nil);

			if config.useObjects then
				self.__prototype.constructor = pl.PrototypeItem.new(self, function(...)
					return constructor(...);
				end)
			else
				self.__prototype.constructor = function(...)
					return constructor(...);
				end
			end
		end


		_G.Protos[self.__name] = self;

		return self;

	end end
  
end
