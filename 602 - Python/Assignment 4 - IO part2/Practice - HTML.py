import urllib
sock = urllib.urlopen("http://diveintopython.net/")
htmlSource = sock.read()
sock.close()
#print htmlSource


def foo(arg):
    x=1
    test = locals()
    #print locals()
    locals()["x"] = 2
    #print x
    #print "%(x)s" %test

foo(7)


def unicode():
    s = u'Lfa Pve\xf1a'
    print s.encode('latin-1')

def russian_unicode():
    s = u'Lfa Pve\xf1a'
    print s.encode('latin-1')

if __name__=="__main__":
    from xml.dom import  minidom
    xmldoc = minidom.parse('G:\\Google_drive\\CUNY\Courses\\CUNY-repository\\602 - Python\\diveintopython - materials\\kgp\\kant.xml')
    xmldoc_res = minidom.parse('G:\\Google_drive\\CUNY\Courses\\CUNY-repository\\602 - Python\\diveintopython - materials\\kgp\\russiansample.xml')
    print xmldoc_res
     #xmldoc.toxml()
    #print xmldoc.childNodes[1].childNodes[1].toxml()
    unicode()
