# george trammell
# this script downloads and merges PDFs from GCP documentation, uses a temp folder that it automatically cleans up if successful
from selenium import webdriver
from bs4 import BeautifulSoup
import pdfkit
from PyPDF2 import PdfMerger
import os

def scrape_links(product, sub_product): # placeholders for user input
    # selenium
    browser = webdriver.Firefox()  # must have geckodriver installed and in PATH
    url = f'https://cloud.google.com/docs/terraform'
    browser.get(url)
    html = browser.page_source
    browser.quit()

    # bs4 parsing for links
    soup = BeautifulSoup(html, 'html.parser')
    links = soup.find_all('a', href=True)

    # filter links for given product/service preference
    filtered_links = [link['href'] for link in links if 'cloud.google.com' and 'docs/terraform/' in link['href']]
    return filtered_links

def merge_pdfs(links, output_pdf_path):
    temp_pdf_dir = 'temp_pdfs'
    os.makedirs(temp_pdf_dir, exist_ok=True)
    
    # duplicate handler
    done_list = []
    # download each page as PDF
    for index, link in enumerate(links):
        pdf_output_filename = os.path.join(temp_pdf_dir, f'document_{index}.pdf')

        # stupid testing handler
        if link[:5] == "/docs":
            link = "https://cloud.google.com" + link
        # duplicate handler
        if link in done_list:
            continue
        # debug
        print("created from: ", link)
        done_list.append(link)

        # error handling (doesn't seem to work yet)
        try:
            pdfkit.from_url(link, pdf_output_filename)
        except OSError as e:
            print("Error: ", e)
            continue
    
    # merge to one big document at the end
    merger = PdfMerger()
    for pdf_file in os.listdir(temp_pdf_dir):
        merger.append(os.path.join(temp_pdf_dir, pdf_file))
    
    merger.write(output_pdf_path)
    merger.close()
    
    # cleanup
    for pdf_file in os.listdir(temp_pdf_dir):
        os.remove(os.path.join(temp_pdf_dir, pdf_file))
    os.rmdir(temp_pdf_dir)

# ------------
# MAIN
# ------------
# NOT WORKING YET user input
product = "Terraform"
sub_product = ""
links = scrape_links(product, sub_product)
print(links)
output_pdf_path = 'merged_document.pdf'
merge_pdfs(links, output_pdf_path)
