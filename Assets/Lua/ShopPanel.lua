--继承基类
BasePanel:subClass("ShopPanel")
--"成员变量"
ShopPanel.Content = nil
--用来存储当前显示的格子
ShopPanel.items = {}
--用来显示的页签类型 避免重复刷新
ShopPanel.nowType = -1
ShopPanel.itemDes = nil

function ShopPanel:Init(name)
    self.base.Init(self, name)
    if self.isInitEvent == false then
        self.Content = self:GetControl("svBag","ScrollRect").transform:Find("Viewport"):Find("Content")
        self:GetControl("togAll","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(4)
            end
        end)
        self:GetControl("togEquip","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(1)
            end
        end)
        self:GetControl("togItem","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self:GetControl("togGam","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(3)
            end
        end)
        self:GetControl("btnClose","Button").onClick:AddListener(function ()
            self:HideMe()
        end)

        self.itemDes = ItemDes:new()
        self.itemDes:Init(self.panelObj.transform, GridType.shop)
        self.isInitEvent = true
    end
    
end

function ShopPanel:ChangeType(type)
    --如果要打开的是当前界面，就不重复执行了
    if self.nowType == type then
        return
    end
    --设置当前的界面为打开的界面
    self.nowType = type
    --删除所有格子
    for i = 1, #self.items do
        self.items[i]:Destroy()
    end
    self.items = {}
    --创建所有格子
    local nowItems = nil
    if type == 1 then
        nowItems = ShopItemData.equips
    elseif type == 2 then
        nowItems = ShopItemData.items
    elseif type ==3 then
        nowItems = ShopItemData.gems
    else
        nowItems = ShopItemData.all
    end
    --创建格子
    for i = 1, #nowItems do
        local grid = ItemGrid:new()
        grid:Init(self.Content,(i-1)%4 * 165,-math.floor((i-1)/4) * 165,GridType.shop)
        grid:InitData(nowItems[i])
        table.insert(self.items,grid)
        local ItemDesPanel = self.panelObj.transform:Find("ItemDesPanel")
        if ItemDesPanel then
            ItemDesPanel.gameObject:SetActive(false)
        end
    end
end

function ShopPanel:ShowMe(name)
    self.base.ShowMe(self,name)

    if self.nowType == -1 then
        self:ChangeType(4)
        self:GetControl("togAll","Toggle").isOn = true
    end
end

function ShopPanel:HideMe()
    self.base.HideMe(self)
    self.nowType = -1
    local ItemDesPanel = self.panelObj.transform:Find("ItemDesPanel")
    if ItemDesPanel then
        ItemDesPanel.gameObject:SetActive(false)
    end
end