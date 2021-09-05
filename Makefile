publish:
	hugo -d docs
	git add docs
	git add content
	git commit -m "$(date)"
	git push wangyijie master