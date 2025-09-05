ShopItemData = {}

ShopItemData.all = {}
ShopItemData.equips = {}
ShopItemData.items = {}
ShopItemData.gems = {}

function ShopItemData:Init()

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