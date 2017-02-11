phrase = """
It is a really long string
triple-quoted strings are used
to define multi-line strings
"""

print(int(len(phrase)/2))

first_half = phrase[:int(len(phrase)/2)]
print(first_half)
