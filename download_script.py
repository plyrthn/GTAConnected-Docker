import sys
import requests
from bs4 import BeautifulSoup

def get_download_link(os_type, architecture):
    base_url = 'https://gtaconnected.com'
    url = f'{base_url}/downloads/'
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    download_links = {
        'Windows': {
            '32-bit': None,
            '64-bit': None
        },
        'Linux': {
            'AMD64': None,
            'ARM64': None
        }
    }

    # Finding the server download section in the HTML
    server_section = soup.find('h3', string='Server').find_next_sibling('ul')
    for item in server_section.find_all('li'):
        link = item.find('a')
        if 'Win32' in link.text:
            download_links['Windows']['32-bit'] = base_url + link['href']
        elif 'Win64' in link.text:
            download_links['Windows']['64-bit'] = base_url + link['href']
        elif 'Linux' in link.text:
            if 'AMD64' in link.text:
                download_links['Linux']['AMD64'] = base_url + link['href']
            elif 'ARM64' in link.text:
                download_links['Linux']['ARM64'] = base_url + link['href']

    return download_links[os_type][architecture]


if __name__ == "__main__":
    os_type = sys.argv[1]  # 'Windows' or 'Linux'
    architecture = sys.argv[2]  # '32-bit', '64-bit', 'AMD64', or 'ARM64'
    print(get_download_link(os_type, architecture))
