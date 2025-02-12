package schema

type Resource interface {
	Typename() string
	ToJson() string
}
