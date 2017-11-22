copy `[desktop/laptop].Xresources` in ~ then:
```bash
$ xrdb -remove && xrdb -merge .Xresource
```

to check the curent settings:
```bash
$ xrdb -q
```
