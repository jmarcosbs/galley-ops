push-all:
	git push
	git -C a4-menu push
	git -C app push
	git -C driver push
	git -C landing push
	git -C service push

pull-all:
	git pull
	git -C a4-menu pull
	git -C app pull
	git -C driver pull
	git -C landing pull
	git -C service pull