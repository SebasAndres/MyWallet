from django.test import TestCase
from scripts.firestore import register_in_category

# TESTS
register_in_category("UserKey1", -100, "Comida")