import urllib
import json
import re
import watson_developer_cloud
from bs4 import BeautifulSoup
from prettytable import PrettyTable


def extract_links(pass_url):
    sock = urllib.urlopen(pass_url)
    html_source = sock.read()
    sock.close()
    soup = BeautifulSoup(html_source)
    press_office_pattern = "/the-press-office/.*"
    find_links = soup.find_all('a')

    final_list = list(links.get('href') for links in find_links)

    # For Links in one page

    regex_list = []
    for string_final in final_list:
        if re.search(press_office_pattern, string_final) != None:
            regex_list.append(re.search(press_office_pattern, string_final).group())

    full_links = ['https://www.whitehouse.gov' + stringss for stringss in regex_list]
    return full_links


if __name__ == "__main__":
    pass_url = "https://www.whitehouse.gov/briefing-room/statements-and-releases"

    page_list = ['https://www.whitehouse.gov/briefing-room/statements-and-releases?term_node_tid_depth=41&page=' + str(num) for num in range(1, 10)]

    all_page_result = []
    all_page_flat = []

    for page in page_list:
        all_page_result.append(extract_links(page))

    all_page_flat = [item for sublist in all_page_result for item in sublist]

    # all_page_flat = [u'https://www.whitehouse.gov/the-press-office/2017/02/28/president-trump-delivers-jobs-american-people', u'https://www.whitehouse.gov/the-press-office/2017/02/28/president-trumps-first-40-days-action-achieving-results-american-people', u'https://www.whitehouse.gov/the-press-office/2017/02/28/excerpts-president-donald-j-trumps-address-joint-session-congress', u'https://www.whitehouse.gov/the-press-office/2017/02/28/president-donald-j-trump-signs-hr-255-hr-321-and-hjres-40', u'https://www.whitehouse.gov/the-press-office/2017/02/28/president-donald-j-trump-and-first-lady-melania-trump-announce-special', u'https://www.whitehouse.gov/the-press-office/2017/02/27/readout-white-house-historically-black-colleges-universities-hbcus', u'https://www.whitehouse.gov/the-press-office/2017/02/27/icymi-president-trump-seeks-outdo-obama-backing-black-colleges', u'https://www.whitehouse.gov/the-press-office/2017/02/27/background-briefing-president-donald-j-trumps-address-joint-session', u'https://www.whitehouse.gov/the-press-office/2017/02/27/white-house-national-economic-council-director-announces-senior-staff', u'https://www.whitehouse.gov/the-press-office/2017/02/26/president-donald-j-trump-and-first-lady-melania-trump-welcome-governors', u'https://www.whitehouse.gov/the-press-office/2017/02/26/top-highlights-sundays-shows', u'https://www.whitehouse.gov/the-press-office/2017/02/25/readout-presidents-lunch-florida-governor-rick-scott-and-wisconsin', u'https://www.whitehouse.gov/the-press-office/2017/02/24/readout-presidents-meeting-president-pedro-pablo-kuczynski-peru', u'https://www.whitehouse.gov/the-press-office/2017/02/24/president-trump-cuts-through-more-red-tape', u'https://www.whitehouse.gov/the-press-office/2017/02/24/icymi-president-trumps-focus-brings-renewed-optimism-americas', u'https://www.whitehouse.gov/the-press-office/2017/02/24/president-trump-approves-kansas-disaster-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/23/readout-presidents-call-prime-minister-justin-trudeau-canada', u'https://www.whitehouse.gov/the-press-office/2017/02/21/readout-vice-presidents-meeting-australian-foreign-minister-julie-bishop', u'https://www.whitehouse.gov/the-press-office/2017/02/21/statement-president-donald-j-trump-death-russias-permanent', u'https://www.whitehouse.gov/the-press-office/2017/02/20/president-donald-j-trump-names-lt-general-hr-mcmaster-assistant-president', u'https://www.whitehouse.gov/the-press-office/2017/02/20/president-donald-j-trumps-first-month-achieving-results-american-people', u'https://www.whitehouse.gov/the-press-office/2017/02/19/readout-presidents-call-prime-minister-keith-rowley-trinidad-and-tobago', u'https://www.whitehouse.gov/the-press-office/2017/02/19/readout-presidents-call-president-juan-carlos-varela-panama', u'https://www.whitehouse.gov/the-press-office/2017/02/19/readout-vice-presidents-meeting-belgian-prime-minister-charles-michel', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-ukrainian-president-petro-poroshenko', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-prime-minister-yildirim-turkey', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-presidents-lithuania-latvia-and-estonia', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-president-iraqi-kurdistan-region-masoud', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-prime-minister-abadi-iraq', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-president-ghani-islamic-republic', u'https://www.whitehouse.gov/the-press-office/2017/02/18/readout-vice-presidents-meeting-german-chancellor-angela-merkel', u'https://www.whitehouse.gov/the-press-office/2017/02/17/president-trump-approves-nevada-disaster-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/17/readout-presidents-call-president-beji-caid-essebsi-tunisia', u'https://www.whitehouse.gov/the-press-office/2017/02/16/readout-presidents-call-president-mauricio-macri-argentina', u'https://www.whitehouse.gov/the-press-office/2017/02/16/readout-vice-presidents-african-american-economic-opportunity-listening', u'https://www.whitehouse.gov/the-press-office/2017/02/16/icymi-democrats-supreme-court-double-standard', u'https://www.whitehouse.gov/the-press-office/2017/02/16/president-trump-putting-coal-country-back-work', u'https://www.whitehouse.gov/the-press-office/2017/02/16/president-donald-j-trump-nominates-r-alexander-acosta-be-secretary-labor', u'https://www.whitehouse.gov/the-press-office/2017/02/16/readout-vice-presidents-meeting-prime-minister-benjamin-netanyahu-israel', u'https://www.whitehouse.gov/the-press-office/2017/02/15/joint-readout-meeting-between-president-donald-j-trump-and-israeli-prime', u'https://www.whitehouse.gov/the-press-office/2017/02/15/readout-presidents-call-president-jacob-zuma-south-africa', u'https://www.whitehouse.gov/the-press-office/2017/02/15/readout-presidents-call-president-muhammadu-buhari-nigeria', u'https://www.whitehouse.gov/the-press-office/2017/02/15/icymi-former-law-clerks-herald-supreme-court-nominee-neil-gorsuchs', u'https://www.whitehouse.gov/the-press-office/2017/02/15/president-donald-j-trump-congratulates-president-elect-frank-walter', u'https://www.whitehouse.gov/the-press-office/2017/02/14/president-trump-approves-disaster-declaration-hoopa-valley-tribe', u'https://www.whitehouse.gov/the-press-office/2017/02/14/president-trump-approves-california-disaster-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/14/president-trump-approves-california-emergency-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/14/president-trump-cutting-red-tape-american-businesses', u'https://www.whitehouse.gov/the-press-office/2017/02/14/first-lady-melania-trump-announces-reopening-white-house-visitors-office', u'https://www.whitehouse.gov/the-press-office/2017/02/13/president-donald-j-trump-names-lt-general-joseph-keith-kellogg-jr-acting', u'https://www.whitehouse.gov/the-press-office/2017/02/10/readout-presidents-call-prime-minister-haider-al-abadi-iraq', u'https://www.whitehouse.gov/the-press-office/2017/02/10/readout-presidents-call-his-highness-sheikh-tamim-bin-hamad-al-thani', u'https://www.whitehouse.gov/the-press-office/2017/02/10/readout-presidents-call-his-highness-sheikh-sabah-al-ahmad-al-jabir-al', u'https://www.whitehouse.gov/the-press-office/2017/02/10/president-trump-approves-oklahoma-disaster-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/10/joint-statement-president-donald-j-trump-and-prime-minister-shinzo-abe', u'https://www.whitehouse.gov/the-press-office/2017/02/09/readout-presidents-call-president-xi-jinping-china', u'https://www.whitehouse.gov/the-press-office/2017/02/09/readout-presidents-call-president-ghani-islamic-republic-afghanistan', u'https://www.whitehouse.gov/the-press-office/2017/02/08/statement-press-secretary', u'https://www.whitehouse.gov/the-press-office/2017/02/08/first-lady-melania-trump-announces-appointment-anna-christina-niceta', u'https://www.whitehouse.gov/the-press-office/2017/02/08/icymi-cnbc-ceo-confidence-near-record-high-why-trumps-war-regulation', u'https://www.whitehouse.gov/the-press-office/2017/02/08/president-donald-j-trump-announces-his-cabinet', u'https://www.whitehouse.gov/the-press-office/2017/02/07/readout-presidents-call-prime-minister-mariano-rajoy-spain', u'https://www.whitehouse.gov/the-press-office/2017/02/07/readout-vice-presidents-meeting-right-try-advocates', u'https://www.whitehouse.gov/the-press-office/2017/02/07/readout-presidents-call-president-recep-tayyip-erdo%C4%9Fan-turkey', u'https://www.whitehouse.gov/the-press-office/2017/02/07/white-house-director-legislative-affairs-announces-legislative-affairs', u'https://www.whitehouse.gov/the-press-office/2017/02/07/second-lady-announces-kristan-king-nevins-chief-staff', u'https://www.whitehouse.gov/the-press-office/2017/02/07/case-you-missed-it-mcclatchy-historical-precedent-presidents-national', u'https://www.whitehouse.gov/the-press-office/2017/02/06/president-trump-announces-presidential-delegation-republic-haiti-attend', u'https://www.whitehouse.gov/the-press-office/2017/02/05/radio-interview-president-trump-jim-gray-westwood-one-sports-radio', u'https://www.whitehouse.gov/the-press-office/2017/02/05/readout-presidents-call-prime-minister-bill-english-new-zealand', u'https://www.whitehouse.gov/the-press-office/2017/02/05/readout-presidents-call-nato-secretary-general-jens-stoltenberg', u'https://www.whitehouse.gov/the-press-office/2017/02/56/top-highlights-sundays-shows', u'https://www.whitehouse.gov/the-press-office/2017/02/04/readout-presidents-call-president-petro-poroshenko-ukraine', u'https://www.whitehouse.gov/the-press-office/2017/02/04/readout-presidents-call-prime-minister-paolo-gentiloni-italy', u'https://www.whitehouse.gov/the-press-office/2017/02/04/promise-make-america-safe-again', u'https://www.whitehouse.gov/the-press-office/2017/02/04/president-trumps-second-week-action', u'https://www.whitehouse.gov/the-press-office/2017/02/04/getting-americans-back-work', u'https://www.whitehouse.gov/the-press-office/2017/02/03/statement-press-secretary', u'https://www.whitehouse.gov/the-press-office/2017/02/03/statement-national-security-advisor-michael-t-flynn-iran', u'https://www.whitehouse.gov/the-press-office/2017/02/03/president-donald-j-trump-recognizes-national-catholic-schools-week', u'https://www.whitehouse.gov/the-press-office/2017/02/02/statement-press-secretary', u'https://www.whitehouse.gov/the-press-office/2017/02/02/readout-vice-presidents-meeting-german-vice-chancellor-and-minister', u'https://www.whitehouse.gov/the-press-office/2017/02/02/readout-presidents-meeting-king-abdullah-ii-jordan', u'https://www.whitehouse.gov/the-press-office/2017/02/02/president-donald-j-trump-proclaims-february-national-african-american', u'https://www.whitehouse.gov/the-press-office/2017/02/02/white-house-national-security-advisor-announces-nsc-senior-staff-0', u'https://www.whitehouse.gov/the-press-office/2017/02/01/first-lady-melania-trump-announces-chief-staff', u'https://www.whitehouse.gov/the-press-office/2017/02/01/vice-president-mike-pence-announces-jarrod-agen-director-communications', u'https://www.whitehouse.gov/the-press-office/2017/02/01/president-trump-approves-south-dakota-disaster-declaration', u'https://www.whitehouse.gov/the-press-office/2017/02/01/statement-national-security-advisor', u'https://www.whitehouse.gov/the-press-office/2017/02/01/editorial-boards-across-country-praise-judge-gorsuch']
    print all_page_flat

    # Update API Key
    alchemy_language = watson_developer_cloud.AlchemyLanguageV1(api_key='XXXXXXXXXX')

    complete_json = []

    for one_url in all_page_flat:
         complete_json.append([json.loads(json.dumps(alchemy_language.sentiment(url=one_url), indent=2)), \
                              json.loads(json.dumps(alchemy_language.emotion(url=one_url), indent=2))])
    t_score = PrettyTable(['URL', 'Score', 'Type'])
    t_emotion = PrettyTable(['URL', 'Anger', 'Disgust', 'Fear', 'Joy', 'Sadness'])
    for i in range(0, len(complete_json)):
        try:
            t_score.add_row([complete_json[i][0]["url"], complete_json[i][0]["docSentiment"]["score"], complete_json[i][0]["docSentiment"]["type"]])
            t_emotion.add_row([complete_json[i][1]["url"], complete_json[i][1]["docEmotions"]["anger"], complete_json[i][1]["docEmotions"]["disgust"], complete_json[i][1]["docEmotions"]["fear"], \
                    complete_json[i][1]["docEmotions"]["joy"], complete_json[i][1]["docEmotions"]["sadness"]])
        except Exception as error:
            print "score or emotion is not found"
    output_file_score = open("Output_score.txt", "w")
    output_file_emotions = open("Output_emotions.txt", "w")
    print "\n", "Output saved to file:"
    output_file_score.write(str(t_score))
    output_file_emotions.write(str(t_emotion))
    output_file_score.close()
    output_file_emotions.close()
    print t_score
    print t_emotion
