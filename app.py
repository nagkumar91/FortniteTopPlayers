import requests
from bs4 import BeautifulSoup as bs

URL = "https://fortnitetracker.com/leaderboards/psn/Top1?platform=psn&mode=all"


def lambda_handler(event, context):
    """
    Lambda handler
    :param event:
    :param context:
    :return: json of top fortnite players
    """
    data = []
    top_players = []
    response = requests.get(URL)
    if response.status_code == 200:
        soup = bs(response.content, 'html.parser')
        table_needed = soup.find_all("table", class_="card-table-material")[0]
        table_body = table_needed.find('tbody')
        rows = table_body.find_all('tr')
        for row in rows:
            columns = row.find_all('td')
            columns = [element.text.strip() for element in columns]
            for element in columns:
                if element and not element.startswith("if"):
                    data.append([element for element in columns if element])
    for row in data:
        info = row[1].split("\n")
        top_players.append(info[0])
    return top_players


if __name__ == "__main__":  # pragma: no cover
    print(lambda_handler(None, None))
