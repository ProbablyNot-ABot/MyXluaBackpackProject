ItemManager = {}
local instance = nil 

function ItemManager.Instance()
    if not instance then
       instance = {}
       setmetatable(instance,{__index = ItemManager})
       print("已创建ItemManager单例实例")
    end
    return instance
end

function ItemManager:BuyItem(itemId, count)
    if self == ItemManager then
        return ItemManager.Instance():BuyItem(itemId, count)
    end
    print("ItemId",itemId)
    print("count",count)
    if not itemId or not count or count <= 0 then
        print("无效的购买参数")
        return false
    end
    -- 获取道具配置
    local itemConfig = ItemData[itemId]
    if not itemConfig then
        print("找不到道具ID为 " .. itemId .. " 的配置")
        TipsPanel:Show(false)
        return false
    end
    -- TODO: 判断金钱逻辑
    self:AddItemToPlayer(itemId, count)
    print("购买成功！")
    TipsPanel:Show(true)
    return true
end

function ItemManager:AddItemToPlayer(itemId,count)
    if not PlayerData then
        print("PlayerData 未初始化")
        return false
    end
    -- 根据道具类型添加到不同的背包分类
    local itemConfig = ItemData[itemId]
    if not itemConfig then 
        return false 
    end
    local targetList = nil
    -- 根据道具类型选择目标列表
    if itemConfig.type == 1 then
        targetList = PlayerData.equips  -- 装备
    elseif itemConfig.type == 2 then
        targetList = PlayerData.items   -- 物品
    elseif itemConfig.type == 3 then
        targetList = PlayerData.gems    -- 宝石
    else
        print("未知的道具类型")
        return false
    end
     -- 查找是否已有该道具
    local found = false
    for _, item in ipairs(targetList) do
        if item.id == itemId then
            -- 已有该道具，增加数量
            item.num = item.num + count
            found = true
            break
        end
    end
    -- 如果没有该道具，添加新条目
    if not found then
        table.insert(targetList, {id = itemId, num = count})
    end
    print("成功添加 " .. count .. " 个道具(ID:" .. itemId .. ")到背包")
    return true
end

setmetatable(ItemManager,{
    __call = function(tab)
        return tab.Instance()
    end
})