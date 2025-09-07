ShopItemData = {}
local instance = nil 

function ShopItemData.Instance()
    if not instance then
       instance = {}
       setmetatable(instance,{__index = ShopItemData})
       print("已创建ShopItemData单例实例")
       instance:Initialize()
    end
    return instance
end

-- 初始化方法
function ShopItemData:Initialize()
    -- 初始化数据表
    self.all = {}
    self.equips = {}
    self.items = {}
    self.gems = {}
    print("ShopItemData 单例初始化完成")
end

function ShopItemData:Init()
    self.all = {}
    self.equips = {}
    self.items = {}
    self.gems = {}
    for _, v in ipairs(ItemData) do
        table.insert(self.all,{id = v.id,num = -1})

        if v.type == 1 then
            --print("this is equip")
            table.insert(self.equips,{id = v.id,num = -1})
        elseif v.type == 2 then
            --print("this is item")
            table.insert(self.items,{id = v.id,num = -1})
        elseif v.type == 3 then
            --print("this is gem")
            table.insert(self.gems,{id = v.id,num = -1})
        end
    end
    print("ShopItemData Init Finish")
end

function ShopItemData:GetItemsByType(itemType)
    if itemType == 1 then
        return self.equips
    elseif itemType == 2 then
        return self.items
    elseif itemType == 3 then
        return self.gems
    elseif itemType == 4 then
        return self.all
    else
        return {}
    end
end

function ShopItemData.InitData()
    return ShopItemData.Instance():Init()
end

setmetatable(ShopItemData,{
    __call = function(tab)
        return tab.Instance()
    end
})