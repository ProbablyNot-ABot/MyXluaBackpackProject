using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class LuaCopyEditor : Editor
{
    [MenuItem("XLua/�Զ�����txt��׺��Lua")]
    public static void CopyLuaToTxt()
    {
        //����Ҫ�ҵ����ǵ� ����Lua�ļ�
        string path = Application.dataPath + "/Lua/";
        //�ж�·���Ƿ����
        if(!Directory.Exists(path))
        {
            Debug.LogError("Lua�ļ��в����ڣ�����·����" + path);
            return;
        }
        //�õ�ÿһ��lua�ļ���·�� ���ܽ���Ǩ�ƿ��� ��׺��Ϊ.lua��
        string[] strs = Directory.GetFiles(path,"*.lua");

        //Ȼ���Lua�ļ����Ƶ�һ���µ��ļ�����
        //���ȶ�һ���µ��ļ���·��
        string newPath = Application.dataPath + "/LuaTxt/";

        //Ϊ�˱���һЩ��ɾ����lua�ļ� ����ʹ�� ����Ӧ�������Ŀ���ļ���·��

        //�ж��µ�·���ļ����Ƿ����
        if (!Directory.Exists(newPath))
            Directory.CreateDirectory(newPath);
        else
        {
            //�õ���·��������.txt���ļ� ������ȫ��ɾ��
            string[] oldFiles = Directory.GetFiles(newPath, "*.txt");
            for (int i = 0; i < oldFiles.Length; i++)
            {
                //ɾ���ļ�
                File.Delete(oldFiles[i]);
            }
        }

        List<string> newFileNames = new List<string>();
        string fileName;
        for (int i = 0; i < strs.Length; i++)
        {
            fileName = newPath + strs[i].Substring(strs[i].LastIndexOf("/") + 1) + ".txt";
            newFileNames.Add(fileName);
            File.Copy(strs[i], fileName);
        }

        AssetDatabase.Refresh();

        //ˢ�¹���������ָ��λ�� ��Ϊ �����ˢ�� ��һ�θĻ�û��
        for (int i = 0; i < newFileNames.Count; i++)
        {
            //Unity API
            //��API�����·�������� ���Assets�ļ��е� Assets/..../....
            AssetImporter importer = AssetImporter.GetAtPath(newFileNames[i].Substring(newFileNames[i].IndexOf("Assets")));
            if(importer != null)
            {
                importer.assetBundleName = "lua";
            }
        }
    }
}
