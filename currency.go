// Copyright (c) 2024 Kevin Damm
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// github:kevindamm/cratedig/currency.go

package cratedig

type CurrencyEnum string

func (currency CurrencyEnum) Name() string {
	return currency_names[currency]
}

const (
	CurrencyUSD CurrencyEnum = "USD"
	CurrencyGBP CurrencyEnum = "GBP"
	CurrencyEUR CurrencyEnum = "EUR"
	CurrencyCAD CurrencyEnum = "CAD"
	CurrencyAUD CurrencyEnum = "AUD"
	CurrencyJPY CurrencyEnum = "JPY"
	CurrencyCHF CurrencyEnum = "CHF"
	CurrencyMXN CurrencyEnum = "MXN"
	CurrencyBRL CurrencyEnum = "BRL"
	CurrencyNZD CurrencyEnum = "NZD"
	CurrencySEK CurrencyEnum = "SEK"
	CurrencyZAR CurrencyEnum = "ZAR"
)

var currency_names = map[CurrencyEnum]string{
	CurrencyUSD: "U.S. Dollar",
	CurrencyGBP: "Pound Sterling",
	CurrencyEUR: "Euro",
	CurrencyCAD: "Canadian Dollar",
	CurrencyAUD: "Australian Dollar",
	CurrencyJPY: "Japanese Yen",
	CurrencyCHF: "Swiss Franc",
	CurrencyMXN: "Mexican Peso",
	CurrencyBRL: "Brazilian Real",
	CurrencyNZD: "New Zealand Dollar",
	CurrencySEK: "Swedish Krona",
	CurrencyZAR: "South African rand",
}

// TODO? add symbols (prefix) for each of these too.

func CurrencyOptions() []CurrencyEnum {
	return []CurrencyEnum{
		CurrencyUSD,
		CurrencyGBP,
		CurrencyEUR,
		CurrencyCAD,
		CurrencyAUD,
		CurrencyJPY,
		CurrencyCHF,
		CurrencyMXN,
		CurrencyBRL,
		CurrencyNZD,
		CurrencySEK,
		CurrencyZAR,
	}
}

func CurrencyNames(options []CurrencyEnum) []string {
	names := make([]string, len(options))
	for i, option := range options {
		names[i] = option.Name()
	}
	return names
}
