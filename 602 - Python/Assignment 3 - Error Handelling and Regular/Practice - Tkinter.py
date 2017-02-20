import Tkinter

import pylint as pylint

#Tkinter._test()
from Tkinter import *

def doNothing():
    print("Hello")

root = Tk()
menu = Menu(root)
one = Label(root,text="A:Z",fg="white", bg="red")
root.config(menu=menu)

subMenu = Menu(menu)
menu.add_cascade(label="File",menu=subMenu)
subMenu.add_command(label="New Project..",command=doNothing)
subMenu.add_command(label="New menu..",command=doNothing)
subMenu.add_separator()
subMenu.add_command(label="Exit",command=doNothing)

menu.add_cascade(label="Edit",menu=subMenu)

one.pack()
root.mainloop()
