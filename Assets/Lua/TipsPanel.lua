BasePanel:subClass("TipsPanel")

TipsPanel.txt = nil
TipsPanel.closeBtn = nil

function TipsPanel:Show(txt)
    self.panelObj = ABManager:LoadRes("ui","TipsPanel",typeof(GameObject))
    self.panelObj.transform:SetParent(Canvas,false)
    self.closeBtn = self.panelObj.transform:Find("back"):GetComponent(typeof(Button))
    self.txt = self.closeBtn.transform:Find("tipsTxt"):GetComponent(typeof(Text))
    self.txt.text = txt
    self.closeBtn.onClick:AddListener(function ()
        self:CloseThis()
    end)
end

function TipsPanel:CloseThis()
    
    CS.UnityEngine.Object.Destroy(self.panelObj)
end