import unittest

from app import lambda_handler


class UnitTestToCheckResponse(unittest.TestCase):
    def test_response_has_results(self):
        response = lambda_handler(None, None)
        self.assertGreater(len(response), 1)
