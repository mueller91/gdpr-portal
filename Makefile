all:	html

prod:	html-prod

sass:
	sass themes/docs/assets/scss/main.scss themes/docs/static/css/main.css

html:	beam

html-prod:	beam-prod

beam: sass
	beam -vv up --site src/site.yml

beam-prod: sass
	beam -vv up --site src/site-prod.yml

docs:	beam

law-texts: law-texts-de law-texts-en
law-texts-de:
	 python3 helpers/parse_law.py src/de/gdpr/txt/articles.txt src/de/gdpr/txt/recitals.txt src/de/gdpr/txt/footnotes.txt src/de/gdpr de
law-texts-en:
	 python3 helpers/parse_law.py src/en/gdpr/txt/articles.txt src/en/gdpr/txt/recitals.txt src/en/gdpr/txt/footnotes.txt src/en/gdpr en

clean:
	rm -rf build/*

watch-html: html
	@which inotifywait || (echo "Please install inotifywait";exit 2)
	@while true ; do \
		inotifywait -r helpers src themes -e create,delete,move,modify || break; \
		$(MAKE) html || break; \
	done

watch-docs: docs
	@which inotifywait || (echo "Please install inotifywait";exit 2)
	@while true ; do \
		inotifywait -r helpers src themes -e create,delete,move,modify || break; \
		$(MAKE) docs || break; \
	done
