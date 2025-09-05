-- ItemDes.lua
BasePanel:subClass("ItemDes")

-- 成员变量
ItemDes.imgIcon = nil
ItemDes.txtName = nil
ItemDes.txtDes = nil
ItemDes.isInitialized = false
ItemDes.typeGrid = nil
ItemDes.shopItemId = nil
--商店控件
ItemDes.shopItems = nil
ItemDes.inputField = nil
ItemDes.btnAdd = nil
ItemDes.btnDec = nil
ItemDes.btnBuy = nil

-- 初始化方法
function ItemDes:Init(parentTransform, gridType)
    if self.isInitialized then
        return true
    end
    
    print("ItemDes 初始化，类型: " .. tostring(gridType or "unknown"))
    
    -- 加载预制体
    self.panelObj = ABManager:LoadRes("ui", "ShopItemDes", typeof(GameObject))
    self.panelObj.name = "ItemDesPanel"
    if not self.panelObj then
        print("ABManager 加载失败")
        return false
    end
    
    -- 设置父对象
    if parentTransform then
        self.panelObj.transform:SetParent(parentTransform, false)
        
        -- 设置位置
        if gridType == GridType.bag then
            self.panelObj.transform.localPosition = Vector3(parentTransform.localPosition.x + 60, 85, 0)
            self.panelObj.transform:Find("shopItems").gameObject:SetActive(false)
        else
            local rect = self.panelObj:GetComponent(typeof(CS.UnityEngine.RectTransform))
            rect.anchorMin = Vector2(0,0.5)
            rect.anchorMax = Vector2(0,0.5)
            self.panelObj.transform.localPosition = Vector3(parentTransform.localPosition.x + 340, 85, 0)
        end
    else
        self.panelObj.transform:SetParent(Canvas, false)
    end
    
    self.typeGrid = gridType
    -- 查找控件
    self:FindControls()
    if gridType == GridType.shop then
        -- 添加按钮事件监听
        self:ButtonListene()
    end
    -- 初始隐藏
    self.panelObj:SetActive(false)
    self.isInitialized = true
    return true
end

-- 查找控件
function ItemDes:FindControls()
    if not self.panelObj then return end
    
    self.imgIcon = self.panelObj.transform:Find("imgIcon"):GetComponent(typeof(Image))
    self.txtName = self.panelObj.transform:Find("txtName"):GetComponent(typeof(Text))
    self.txtDes = self.panelObj.transform:Find("txtDes"):GetComponent(typeof(Text))
    if self.typeGrid == GridType.shop then
        self.shopItems = self.panelObj.transform:Find("shopItems")
        self.inputField = self.shopItems:Find("InputField"):GetComponent(typeof(InputField))
        self.btnAdd = self.inputField.transform:Find("btnAdd"):GetComponent(typeof(Button))
        self.btnDec = self.inputField.transform:Find("btnDec"):GetComponent(typeof(Button))
        self.btnBuy = self.shopItems:Find("btnBuy"):GetComponent(typeof(Button))
    end
    local buttonClose = self:GetControl("btnClose","Button")
    -- self:GetControl("btnClose","Button").onClick:AddListener(function ()
    --     self:HideMe()
    -- end)
end

-- 显示道具信息
function ItemDes:ShowItemInfo(itemData) 
    if not self.isInitialized then
        print("ItemDes 未初始化")
        return
    end
    self.shopItemId = itemData.id
    local itemConfig = ItemData[itemData.id]
    self.shopItemNum = 0
    -- 设置图标
    if itemConfig and itemConfig.icon and self.imgIcon then
        local strs = string.split(itemConfig.icon, "_")
        if strs and #strs >= 2 then
            local spriteAtlas = ABManager:LoadRes("ui", strs[1], typeof(SpriteAtlas))
            if spriteAtlas then
                self.imgIcon.sprite = spriteAtlas:GetSprite(strs[2])
            end
        end
    end
    
    -- 设置文本
    if itemConfig then
        if self.txtName then
            self.txtName.text = itemConfig.name or "未知道具"
        end
        if self.txtDes then
            self.txtDes.text = itemConfig.tips or "暂无描述"
        end
    end
    if self.inputField then
        self.inputField.text = ""    
    end
    self:ShowMe()
end

-- 显示面板
function ItemDes:ShowMe()
    if self.panelObj then
        self.panelObj:SetActive(true)
        self.panelObj.transform:SetAsLastSibling()
    end
end

-- 隐藏面板
function ItemDes:HideMe()
    if self.panelObj then
        self.panelObj:SetActive(false)
        print("ItemDes 隐藏")
    end
end

-- 检查是否显示
function ItemDes:IsShowing()
    return self.panelObj and self.panelObj.activeSelf
end

-- 添加按钮点击事件监听
function ItemDes:ButtonListene()
    self.btnAdd.onClick:AddListener(function ()
        self:AddValue()
    end)
    self.btnDec.onClick:AddListener(function ()
        self:DecValue()
    end)
    self.btnBuy.onClick:AddListener(function ()
        ItemManager.Instance():BuyItem(self.shopItemId,tonumber(self.inputField.text) or 0)
    end)
end

-- 点击增加按钮
function ItemDes:AddValue()
    local currentNum = tonumber(self.inputField.text) or 0 --如果转换失败，默认为0
    currentNum = currentNum + 1
    if currentNum > 999 then
        currentNum = 999
    end
    self.inputField.text = tostring(currentNum)
end

--点击减少按钮
function ItemDes:DecValue()
    local currentNum = tonumber(self.inputField.text) or 0 --如果转换失败，默认为0
    currentNum = currentNum - 1
    if currentNum < 0 then
        currentNum = 0
    end
    self.inputField.text = tostring(currentNum)
end


