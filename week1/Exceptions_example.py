from traceback import print_exc
from CustomExceptions import BadUserInputError

def getUserInput() -> int:
    userIn = int(input("Enter number:\n>>>"))
    if userIn == 8:
        raise BadUserInputError
    return userIn




while True:
    
    try:
        age = int(input("Enter age please:\n>>>"))
        userIn = getUserInput()
        num = 5 / userIn
    except ValueError as ve:
        # print_exc()
        print("SORRY!! Cannot enter a string for an age...")
    # except ZeroDivisionError as zde:
    #     print("SORRY!! CANNOT DIVIDE BY 0!")
    except BadUserInputError as bie:
        print("SORRY!! WE DO NOT LIKE THE NUMBER 8!")
    except Exception as e:
        print_exc()
        print("Exception was raised... Trying again...")
    else:
        # Only going to run if try block finishes with no errors
        print("No exceptions were thrown! Try block ended")
        break
    finally:
        # Runs no matter what
        print("This is the finally block")

print(age)
print("\n*****************END OF PROGRAM*********************")