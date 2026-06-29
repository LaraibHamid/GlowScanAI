from recommendation.products_dataset import products

def generate_routine(issue):

    routine = {
        "cleanser": None,
        "serum": None,
        "moisturizer": None,
        "sunscreen": None,
        "treatment": None,
        "eye care": None
    }

    for product in products:
        if issue in product["issues"]:
            step = product["step"]

            if routine.get(step) is None:
                routine[step] = product

    result = [p for p in routine.values() if p]

    return result