# Running the Server

## �ѭ�ҷ�辺

`sampctl run` ���Դ panic error (nil pointer dereference) ��ѧ�ҡ��Ŵ gamemode ����� ����繺�ꡢͧ��� sampctl �ͧ �����ѭ�Ңͧ��

## �Ը����

### �й�: �ѹ����������µç

```powershell
# Build �鴡�͹
sampctl build

# �ҡ����ѹ����������µç᷹
.\samp-server.exe
```

### �ҧ���͡: �� sampctl (���͡���Դ panic)

```powershell
sampctl run
# ���������зӧҹ�黡�� �� sampctl �� panic �͹��
```

## ʶҹлѨ�غѹ

? **��� compile �����** - Build successful with 0 problems  
? **Plugins ��Ŵ�����**
- mysql: R41-4
- sscanf: 2.13.8

? **Database �������������** - MySQL successfully connected  
? **Gamemode �ӧҹ��** - GameMode loaded successfully  
? **Autosave �ӧҹ** - Started interval every 300000 ms (5 minutes)

?? **����͹�������Ӥѭ:**
```
AllowAdminTeleport() : function is deprecated. Please see OnPlayerClickMap()
```
- �ѧ��ѹ����ѧ���� ��١ deprecated �����
- �й�����¹�� `OnPlayerClickMap()` callback ᷹�͹Ҥ�

## ����觷���ջ���ª��

```powershell
# Build ��
sampctl build

# ��ǹ���Ŵ dependencies
sampctl ensure

# �ѹ��������� (���Ը��µç᷹)
.\samp-server.exe

# �٢�������ࡨ
sampctl package info

# ���� version tag
sampctl package release
```

## ��ػ

���������ͧ�س**�ӧҹ�黡������ó�**����! ���ͧ�ѹ���� `.\samp-server.exe` �µç ᷹������ `sampctl run` ������ա����§��ꡢͧ sampctl
