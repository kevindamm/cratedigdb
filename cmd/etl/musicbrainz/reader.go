package musicbrainz

import (
	"github.com/kevindamm/cratedigdb/schema"
)

type MusicBrainzData[T schema.Resource] interface {
	Scan() bool
	Next() T
}

func NewScanner[T schema.Resource](path string) MusicBrainzData[T] {

	return &scanner[T]{}
}

type scanner[T schema.Resource] struct {
}

func (scanner *scanner[T]) Scan() bool {
	return true
}

func (scanner *scanner[T]) Next() T {
	var value T
	return value
}
