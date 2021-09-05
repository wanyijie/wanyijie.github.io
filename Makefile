publish:
	hugo -d .\docs
	git add .\docs
	git commit -m "$(date)"
	git push wangyijie master