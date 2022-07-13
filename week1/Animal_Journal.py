from Animals import Animal, Dog, Cat

d1 = Dog("Fido", 10, "brown")
c1 = Cat("Garfield", 15, "orange")

lst_Animals = [d1, c1]

for animal in lst_Animals:
    animal.sleep()
    animal.move()
    animal.getOlder(3)
    print(animal)

# c1._name = "asdf"
c1.setName(5)
print(c1)
