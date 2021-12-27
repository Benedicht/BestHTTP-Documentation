clear

echo 'Killing all Jekyll instances'
tskill ruby
kill -9 $(ps aux | grep '[j]ekyll' | awk '{print $2}')
#clear

echo "Building PDF-friendly HTML site for Best-MQTT ...";
start bundle exec jekyll serve --config _config.yml,pages/best_mqtt/pdfconfigs/config_best_mqtt_pdf.yml;
sleep 15
echo "done";

echo "Building the PDF ...";
prince --javascript --input-list=_pdf_site/pages/best_mqtt/pdfconfigs/prince-list.txt -o pdf/best_mqtt_documentation.pdf;
echo "done";
