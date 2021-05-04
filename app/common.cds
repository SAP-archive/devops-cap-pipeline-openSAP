/*
  Common Annotations shared by all apps
*/

using { sap.capire.bookshop as my } from '../db/schema';
using { sap } from '@sap/cds/common';

extend sap.common.Currencies with {
  // Currencies.code = ISO 4217 alphabetic three-letter code
  // with the first two letters being equal to ISO 3166 alphabetic country codes
  // See also:
  // [1] https://www.iso.org/iso-4217-currency-codes.html
  // [2] https://www.currency-iso.org/en/home/tables/table-a1.html
  // [3] https://www.ibm.com/support/knowledgecenter/en/SSZLC2_7.0.0/com.ibm.commerce.payments.developer.doc/refs/rpylerl2mst97.htm
  numcode  : Integer;
  exponent : Integer; //> e.g. 2 --> 1 Dollar = 10^2 Cent
  minor    : String; //> e.g. 'Cent'
}


/**
 * The Code Lists below are designed as optional extensions to
 * the base schema. Switch them on by adding an Association to
 * one of the code list entities in your models or by:
 * annotate sap.common.Countries with @cds.persistence.skip:false;
 */

context sap.common_countries {

  extend sap.common.Countries {
    regions   : Composition of many Regions on regions._parent = $self.code;
  }

  entity Regions : sap.common.CodeList {
    key code : String(5); // ISO 3166-2 alpha5 codes, e.g. DE-BW
    children  : Composition of many Regions on children._parent = $self.code;
    cities    : Composition of many Cities on cities.region = $self;
    _parent   : String(11);
  }
  entity Cities : sap.common.CodeList {
    key code  : String(11);
    region    : Association to Regions;
    districts : Composition of many Districts on districts.city = $self;
  }
  entity Districts : sap.common.CodeList {
    key code  : String(11);
    city      : Association to Cities;
  }

}


////////////////////////////////////////////////////////////////////////////
//
//	Books Lists
//
annotate my.Books with @(
	UI: {
		Identification: [{Value:title}],
	  SelectionFields: [ ID, author_ID, price, currency_code ],
		LineItem: [
			{Value: ID},
			{Value: title},
			{Value: author.name, Label:'{i18n>Author}'},
			{Value: genre.name},
			{Value: stock},
			{Value: price},
			{Value: currency.symbol, Label:' '},
		]
	}
) {
	author @ValueList.entity:'Authors';
};

////////////////////////////////////////////////////////////////////////////
//
//	Books Details
//
annotate my.Books with @(
	UI: {
  	HeaderInfo: {
  		TypeName: '{i18n>Book}',
  		TypeNamePlural: '{i18n>Books}',
  		Title: {Value: title},
  		Description: {Value: author.name}
  	},
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Books Elements
//
annotate my.Books with {
	ID @title:'{i18n>ID}' @UI.HiddenFilter;
	title @title:'{i18n>Title}';
	genre  @title:'{i18n>Genre}'  @Common: { Text: genre.name,  TextArrangement: #TextOnly };
	author @title:'{i18n>Author}' @Common: { Text: author.name, TextArrangement: #TextOnly };
	price @title:'{i18n>Price}';
	stock @title:'{i18n>Stock}';
	descr @UI.MultiLineText;
}

////////////////////////////////////////////////////////////////////////////
//
//	Genres List
//
annotate my.Genres with @(
	Common.SemanticKey: [name],
	UI: {
		SelectionFields: [ name ],
		LineItem:[
			{Value: name},
			{Value: parent.name, Label: 'Main Genre'},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Genre Details
//
annotate my.Genres with @(
	UI: {
		Identification: [{Value:name}],
		HeaderInfo: {
			TypeName: '{i18n>Genre}',
			TypeNamePlural: '{i18n>Genres}',
			Title: {Value: name},
			Description: {Value: ID}
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>SubGenres}', Target: 'children/@UI.LineItem'},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Genres Elements
//
annotate my.Genres with {
	ID  @title: '{i18n>ID}';
	name  @title: '{i18n>Genre}';
}

////////////////////////////////////////////////////////////////////////////
//
//	Authors List
//
annotate my.Authors with @(
	Common.SemanticKey: [name],
	UI: {
		Identification: [{Value:name}],
		SelectionFields: [ name ],
		LineItem:[
			{Value: ID},
			{Value: name},
			{Value: dateOfBirth},
			{Value: dateOfDeath},
			{Value: placeOfBirth},
			{Value: placeOfDeath},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Author Details
//
annotate my.Authors with @(
	UI: {
		HeaderInfo: {
			TypeName: '{i18n>Author}',
			TypeNamePlural: '{i18n>Authors}',
			Title: {Value: name},
			Description: {Value: dateOfBirth}
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Target: 'books/@UI.LineItem'},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Authors Elements
//
annotate my.Authors with {
	ID @title:'{i18n>ID}' @UI.HiddenFilter;
	name @title:'{i18n>Name}';
	dateOfBirth @title:'{i18n>DateOfBirth}';
	dateOfDeath @title:'{i18n>DateOfDeath}';
	placeOfBirth @title:'{i18n>PlaceOfBirth}';
	placeOfDeath @title:'{i18n>PlaceOfDeath}';
}


////////////////////////////////////////////////////////////////////////////
//
//	Languages List
//
annotate sap.common.Languages with @(
	Common.SemanticKey: [code],
	Identification: [{Value:code}],
	UI: {
		SelectionFields: [ name, descr ],
		LineItem:[
			{Value: code},
			{Value: name},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Language Details
//
annotate sap.common.Languages with @(
	UI: {
		HeaderInfo: {
			TypeName: '{i18n>Language}',
			TypeNamePlural: '{i18n>Languages}',
			Title: {Value: name},
			Description: {Value: descr}
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'},
		],
		FieldGroup#Details: {
			Data: [
				{Value: code},
				{Value: name},
				{Value: descr}
			]
		},
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Currencies List
//
annotate sap.common.Currencies with @(
	Common.SemanticKey: [code],
	Identification: [{Value:code}],
	UI: {
		SelectionFields: [ name, descr ],
		LineItem:[
			{Value: descr},
			{Value: symbol},
			{Value: code},
		],
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Currency Details
//
annotate sap.common.Currencies with @(
	UI: {
		HeaderInfo: {
			TypeName: '{i18n>Currency}',
			TypeNamePlural: '{i18n>Currencies}',
			Title: {Value: descr},
			Description: {Value: code}
		},
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>Extended}', Target: '@UI.FieldGroup#Extended'},
		],
		FieldGroup#Details: {
			Data: [
				{Value: name},
				{Value: symbol},
				{Value: code},
				{Value: descr}
			]
		},
		FieldGroup#Extended: {
			Data: [
				{Value: numcode},
				{Value: minor},
				{Value: exponent}
			]
		},
	}
);

////////////////////////////////////////////////////////////////////////////
//
//	Currencies Elements
//
annotate sap.common.Currencies with {
	numcode @title:'{i18n>NumCode}';
	minor @title:'{i18n>MinorUnit}';
	exponent @title:'{i18n>Exponent}';
}
